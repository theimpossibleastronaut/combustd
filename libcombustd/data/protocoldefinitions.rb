class ProtocolDefinitions
  # Product information
  USB_VENDOR_ID = 0x0471
  USB_PRODUCT_ID = 0x083F

  # Usb endpoints
  ENDPOINT_IN = 0x81
  ENDPOINT_OUT = 0x02
  ENDPOINT_PNP = 0x83
  
  # -- Commands --
  
  # Set a single color, for a specific light
  # Params 0xRR 0xGG 0xBB
  # 0xRR = Red color
  # 0xGG = Green color
  # 0xBB = Blue color
  SET_LIGHT_COLOR = 0x03
  
  # Set a color sequence using delays
  # Params 0xMM 0xMM then a repeated sequence of 0xRR 0xGG 0xBB
  # 0xMM = milliseconds
  # 0xMM = milliseconds
  # 0xRR = Red color
  # 0xGG = Green color
  # 0xBB = Blue color
  SET_TIMED_COLOR_SEQUENCE = 0x72
end