REQUIREMENTS = File.dirname(__FILE__)

require REQUIREMENTS + "/../../libcombustd/libcombustd"

puts "\nboblight - a small tool to listen to the output of boblight popen to control a set of Philips Ambx lights.\n"
puts "See README and docs/ for faq, usage and support.\n\n"
puts "Looking for support ?\nChat: irc.oceanius.com #dev\nMail: combustd@sexybiggetje.nl\n\n"

if Ambx.connect
  if Ambx.open
      while true
	r, g, b, excess = gets.split(" ",4)
      	Ambx.write([0xA1, 0x0B, 0x03, Float(r)*255, Float(g)*255, Float(b)*255])
        r, g, b, excess = gets.split(" ",4)
      	Ambx.write([0xA1, 0x2B, 0x03, Float(r)*255, Float(g)*255, Float(b)*255])
        r, g, b, excess = gets.split(" ",4)
	Ambx.write([0xA1, 0x3B, 0x03, Float(r)*255, Float(g)*255, Float(b)*255])
        r, g, b, excess = gets.split(" ",4)
        Ambx.write([0xA1, 0x4B, 0x03, Float(r)*255, Float(g)*255, Float(b)*255])
        r, g, b, excess = gets.split(" ",4)
        Ambx.write([0xA1, 0x1B, 0x03, Float(r)*255, Float(g)*255, Float(b)*255])
      end
      Ambx.close
  else
    puts "Unable to open the discovered device"
  end
else
  puts "Unable to find a ambx device"
end

