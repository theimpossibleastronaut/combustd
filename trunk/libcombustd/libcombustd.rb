REQUIREMENTPATH = File.dirname(__FILE__)

# ruby-usb; http://www.a-k-r.org/ruby-usb/
# a ruby wrapper around libusb, needs to be compiled from source and gem installed.
require 'usb'

require REQUIREMENTPATH + '/data/protocoldefinitions'
require REQUIREMENTPATH + '/data/lights'
require REQUIREMENTPATH + '/communication/ambx'
