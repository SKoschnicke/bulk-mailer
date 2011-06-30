all = Array.new
File.open('emails_source.txt'){|f| f.readlines}.each do |line|
  next if line.strip.empty?
  next if not line["@"]
  adresses = line.split(",").map{|e| e.strip}
  puts "got #{adresses.size} adresses starting with #{adresses[0..2].inspect}"
  all += adresses
end
puts "#{all.size} adresses"
File.open('real_recipients.txt', 'w') {|f| f.write(all.join("\n")) }
