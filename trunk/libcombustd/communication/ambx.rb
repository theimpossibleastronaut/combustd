require 'singleton'

# Ambx class is a singleton to manage all traffic flowing to the ambx device.
# Handles all connections and errors, which can be boolean checked by the application.

# Example usage:
# Ambx.open
# Ambx.connect
# Ambx.write([0x01, Lights::WWCENTER, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0xFF, 0x00])
# Ambx.close

class Ambx
  include Singleton
  
  @device = nil # device in the usb tree
  @handle = nil # device opened
  
  # Find the device by finding it in the device tree, fail if it's not connected
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
  
  # Open the device if it has been connected before.
  # If the device hasn't been opened yet, try to open it otherwise fail
  def Ambx.open
    if @device.nil?
      if not Ambx.connect
        return false
      end
    end
    
    unless @device.nil?
      @handle = @device.usb_open
      
      # we retry a few times to open the device or kill it
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
  
  # Close the device if it is open.
  # set clearLights to true to try and set the lights back to 0x00
  def Ambx.close (clearLights = false)
    unless @handle.nil?
      if clearLights
        Ambx.write([0xA1, Lights::LEFT, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0x00, 0x00])
        Ambx.write([0xA1, Lights::WWLEFT, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0x00, 0x00])
        Ambx.write([0xA1, Lights::WWCENTER, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0x00, 0x00])
        Ambx.write([0xA1, Lights::WWRIGHT, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0x00, 0x00])
        Ambx.write([0xA1, Lights::RIGHT, ProtocolDefinitions::SET_LIGHT_COLOR, 0x00, 0x00, 0x00])
      end
      
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