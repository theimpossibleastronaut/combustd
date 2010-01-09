require 'singleton'

class Ambx
  include Singleton
  
  @device = nil
  @handle = nil
  
  def Ambx.connect
    USB.devices.each do |dev|
      if dev.idVendor == ProtocolDefinitions::USB_VENDOR_ID && dev.idProduct == ProtocolDefinitions::USB_PRODUCT_ID
        @device = dev
        break
      end
    end
    
    if @device == nil
      return false
    end

    return true
  end
  
  def Ambx.open
    unless @device.nil?
      @handle = @device.usb_open
      unless @handle.nil?
        retries = 0
        begin
          error_code = @handle.usb_claim_interface(0)
          raise CannotClaimInterfaceError unless error_code.nil?
          return true
        rescue CannotClaimInterfaceError
          @handle.usb_detach_kernel_driver_np(0);
          if retries.zero? 
            retries += 1
            retry
          else
            return false
          end
        end
      end
    end
    
    return false
  end
  
  def Ambx.close
    unless @handle.nil?
      @handle.usb_close
    end
    
    unless @device.nil?
      @device = nil
    end
  end
  
  def Ambx.write(bytes)
    unless @handle.nil? && @device.open?
      @handle.usb_interrupt_write(ProtocolDefinitions::ENDPOINT_OUT, bytes.pack('C*'), 0);
    end
  end
end