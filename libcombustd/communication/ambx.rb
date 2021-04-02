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
  @bus = nil # the bus that the device is on
  
  # Find the device by finding it in the device tree, fail if it's not connected
  def Ambx.connect
    LIBUSB::Context.new.devices.each do |dev|
      if dev.idVendor == ProtocolDefinitions::USB_VENDOR_ID && dev.idProduct == ProtocolDefinitions::USB_PRODUCT_ID
        @device = dev
        @bus = dev.bus_number
        break
      end
    end
    
    if @device.nil?
      @handle = nil
      @bus = nil
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
      @handle = @device.open
      # we retry a few times to open the device or kill it
      unless @handle.nil?
        retries = 0
        begin
          begin
            error_code = @handle.claim_interface(0)
          rescue ArgumentError
          end
          
          raise CannotClaimInterfaceError if error_code.nil? # TODO: libusb doesn't return anything on error
          return true
        rescue CannotClaimInterfaceError
          @handle.auto_detach_kernel_driver = true
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
      
      begin
        @handle.close
      rescue Errno::ENXIO
      end
      
      @handle = nil
      @device = nil
    end
    
    unless @device.nil?
      @device = nil
    end
  end
  
  # Write a set of bytes to the usb device, this is our command string. Try to open it if neccesairy.
  def Ambx.write(bytes)
    unless @handle || @device
      #we lost it. see issue #1 on google code.
    end

    unless @handle.nil? && @device.nil?
      begin
        @handle.interrupt_transfer({ endpoint: ProtocolDefinitions::ENDPOINT_OUT, dataOut: bytes.pack('C*'), timeout: 0 })
        # quick fix to not immediatly segfault, but wait for segfault when application quits.
        # need a fix somewhere in ruby_usb, see issue #1 on google code.
      rescue Errno::ENXIO
        Ambx.close        
      end
    end
  end
end