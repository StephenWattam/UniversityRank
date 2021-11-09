#!/usr/bin/env ruby

# Scrapes data from the university list and stores it in a folder

INDEX = '../WebList/weblist.csv'
DIR = 'webdata'

UA = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.56 Safari/537.17'

require 'csv'
require 'shellwords'
require 'fileutils'

# make output dir
`mkdir #{DIR}`

depth = ARGV[0].to_i

CSV.foreach(INDEX, {:headers => true}){|line|

  puts line.field("uni").to_s


  where = File.join(DIR, line.field("uni"))

  FileUtils.mkdir_p(where)

  if depth > 0 then
    `wget -r -l #{depth} -H -k --save-cookies cookies.tmp --keep-session-cookies --max-redirect=5 --referer=#{Shellwords::escape(line.field('url'))} --save-headers --user-agent="#{UA}" --no-directories --no-host-directories -P #{Shellwords::escape(where)} #{Shellwords::escape(line.field("url"))}`
  else
    `wget -k --save-cookies cookies.tmp --keep-session-cookies --max-redirect=5 --referer=#{Shellwords::escape(line.field('url'))} --save-headers --user-agent="#{UA}" --no-directories --no-host-directories -P #{Shellwords::escape(where)} #{Shellwords::escape(line.field("url"))}`
  end
}
