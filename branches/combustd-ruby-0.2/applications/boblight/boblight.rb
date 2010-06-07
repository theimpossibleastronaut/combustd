REQUIREMENTS = File.dirname(__FILE__)

require REQUIREMENTS + "/../../libcombustd/libcombustd"

puts "\nboblight - a small tool to listen to the output of boblight popen to control a set of Philips Ambx lights.\n"
puts "See README and docs/ for faq, usage and support.\n\n"
puts "Looking for support ?\nChat: irc.oceanius.com #dev\nMail: combustd@sexybiggetje.nl\n\n"
puts "Format: ruby boblight.rb r1 g1 b1 r2 g2 b2 r3 g3 b3 r4 g4 b4 r5 g5 b5\n\n"

if Ambx.connect
  if Ambx.open
      while true
		r1, g1, b1, r2, g2, b2, r3, g3, b3, r4, g4, b4, r5, g5, b5 = gets.split(" ", 15)
      	Ambx.write([0xA1, Lights::LEFT, 0x03, Float(r1) * 255, Float(g1) * 255, Float(b1) * 255])
      	Ambx.write([0xA1, Lights::RIGHT, 0x03, Float(r2) * 255, Float(g2) * 255, Float(b2) * 255])
      	Ambx.write([0xA1, Lights::WWLEFT, 0x03, Float(r3) * 255, Float(g3) * 255, Float(b3) * 255])
      	Ambx.write([0xA1, Lights::WWRIGHT, 0x03, Float(r4) * 255, Float(g4) * 255, Float(b4) * 255])
      	Ambx.write([0xA1, Lights::WWCENTER, 0x03, Float(r5) * 255, Float(g5) * 255, Float(b5) * 255])
      end
      Ambx.close
  else
    puts "Unable to open the discovered device"
  end
else
  puts "Unable to find a ambx device"
end

