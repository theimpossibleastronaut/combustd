REQUIREMENTPATH = File.dirname(__FILE__)

# ruby-usb; http://www.a-k-r.org/ruby-usb/
# a ruby wrapper around libusb, needs to be compiled from source and gem installed.
require "libusb"

# Classes for definitions
require REQUIREMENTPATH + '/data/protocoldefinitions'
require REQUIREMENTPATH + '/data/lights'

# Classes for logic
require REQUIREMENTPATH + '/communication/ambx'

# Classes for errors
class CannotClaimInterfaceError < StandardError; end