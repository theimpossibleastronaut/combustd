REQUIREMENTS = File.dirname(__FILE__)

require REQUIREMENTS + "/../../libcombustd/libcombustd"

puts "\nsetcolor - a small utility to configure a set of Philips Ambx lights to a specific color.\n"
puts "See README and docs/ for faq, usage and support.\n\n"
puts "Looking for support ?\nChat: irc.oceanius.com #dev\nMail: combustd@sexybiggetje.nl\n\n"

if Ambx.connect
  if Ambx.open
      Ambx.write([0xA1, 0x0B, 0x03, Integer(ARGV[0]), Integer(ARGV[1]), Integer(ARGV[2])])
      Ambx.write([0xA1, 0x2B, 0x03, Integer(ARGV[0]), Integer(ARGV[1]), Integer(ARGV[2])])
      Ambx.write([0xA1, 0x3B, 0x03, Integer(ARGV[0]), Integer(ARGV[1]), Integer(ARGV[2])])
      Ambx.write([0xA1, 0x4B, 0x03, Integer(ARGV[0]), Integer(ARGV[1]), Integer(ARGV[2])])
      Ambx.write([0xA1, 0x1B, 0x03, Integer(ARGV[0]), Integer(ARGV[1]), Integer(ARGV[2])])
    Ambx.close
  else
    puts "Unable to open the discovered device"
  end
else
  puts "Unable to find a ambx device"
end

