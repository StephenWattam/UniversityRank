#!/usr/bin/env ruby
# 
# Extracts websites from the ucas listings
#
# USAGE: ./regexp.rb 
#

puts "uni,url"

Dir.glob("ucas/index*").each{|f|

  str = File.read(f)

  names = str.scan(/<h3>[A-Z0-9]+\s-\s([^<]+)<\/h3>/).map{|x| x[0]}
  urls = str.scan(/w: <a href="([^"]+)"/).map{|x| x[0]}
  
  urls.each_index{|i|
    puts "\"#{names[i]}\",#{urls[i]}"
  }

}
