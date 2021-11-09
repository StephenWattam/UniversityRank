#!/usr/bin/env ruby
#
# Collates and converts text into a single, unannotated, plaintext file
#

require 'fileutils' # making output dirs
require 'nokogiri'  # parsing html -> text
require 'shellwords' # using pdftotext

# XXX: require the 'pdftotext' utility

OUTPUT_DIR            = "text"
OUT_FILENAME          = "text"
TEMP_FILE             = "/tmp/conv.tmp"
PDF_TEMP_RETURN_FILE  = "/tmp/conv.txt"

# Parses text headers into hash
def parse_headers(head_str)
  headers = {}

  # parse key:value
  head_str.each_line{|l|
    parts = l.chomp.split(":")
    if parts.length > 0 then
      key = parts[0].strip
      value = parts[1..-1].join(":").strip

      headers[key] = value
    end
  }

  return headers
end

# Parses the http string into a hash of headers
# and a body string
#
# requires utf-8 input
def parse_httpstr(str)
  # First, split off headers
  head_end = str =~ /\r\n\r\n/
  return if not head_end

  # split strings
  head_str = str[0.. (head_end) - 1].to_s
  body_str = str[head_end+4..-1].to_s

  # parse into hash
  headers = parse_headers(head_str)


  return headers, body_str
end


# intelligently converts http returns to utf-8 by
# pre-parsing their headers
def to_utf8(http_str)
  # We don't know what encoding it's in yet.
  # It's basically either latin1, 8859-1 or utf8, 
  # but it's prudent to find the header anyway.  For this, manually search headers
  # under the assumption that we have loaded the correct charset, then convert the
  # string using the one we read.
  
  charset   = nil
  in_header = true
  
  http_str.lines.each{|l|
    l.chomp!
    in_header = false if l == ""

    if in_header
      parts = l.split(":")
       if parts[0].to_s.strip =~ /^Content-Type$/i then
          ct = parts[1..-1].join(":").to_s
          if ct =~ /charset=([a-zA-Z0-9\-]+)/
            charset = $1.upcase
            
            # correct for idiotic web server config
            charset = 'UTF-8' if charset == 'UTF8'             
            charset = nil if charset == 'NONE' 
            charset = 'ISO-8859-1' if charset == 'IOS-8859-1' # yes, someone actually did this 
          end
       end
    end
  }

  http_str.encode 'UTF-8', (charset)? charset : 'UTF-8', {:invalid => :replace, :undef => :replace}
end




Dir.glob(File.join(ARGV[0], "*")){|d|
  puts "[uni] Institution: #{d}"

  # open file for writing
  file_out = File.open("#{d}.txt", 'w') if File.directory?(d)
    
  Dir.glob(File.join(d, "*")){|f|
    if not File.directory?(f)

      # parse http response.
      headers, body = parse_httpstr(to_utf8(File.read(f)))
      headers = {} if not headers

      # First, split by MIME.  We want to process only text/html and text/plain
      if headers['Content-Type'] =~ /text\/html/ then
        print "[htm]"


        # Nokogiri version (sucks)
        # ------------------------------------------
        # HTML2TXT --- use nokogiri
        # dom =  Nokogiri::HTML(body)
        # body = dom.at('body') if dom
        # text = body.inner_text if body
        # file_out.write(text) if text
        # words are defined by scanning \w possibly too simple.
        # words = text.encode('UTF-8', 'UTF-8', {:invalid => :replace, :undef => :replace}).scan(/\w+/) if text
        # file_out.write(words.join(" ")) if words
        # ------------------------------------------
        #
        # html2text version (sucks less)
        File.open(TEMP_FILE, 'w'){|fo| fo.write(body) }
        text = `html2text -nobs -style compact #{Shellwords::escape(TEMP_FILE)}`
        text.encode!('UTF-8', 'ISO-8859-1')

        file_out.write(text)

      elsif headers['Content-Type'] =~ /text\/plain/ then
        print "[txt]"
        # Check it looks like english before we dump it to output
        if f.to_s =~ /robots.txt/
          print "[robots]"
        elsif f.to_s =~ /.css/
          print "[css]"
        elsif f.to_s =~ /.js/
          print "[js]"
        elsif f.to_s =~ /.php/
          print "[php]"
        elsif f.to_s =~ /.ico/
          print "[ico]"
        else
          file_out.write(body)
        end
      elsif f.to_s =~ /\.pdf$/ then
        # convert from PDF
        print "[pdf]"
      
        # copy to temp folder
        FileUtils.cp(f, TEMP_FILE)
        
        # convert
        `pdftotext -enc UTF-8 #{Shellwords::escape(TEMP_FILE)}`

        # copy back
        out = nil
        out = File.read(PDF_TEMP_RETURN_FILE) if File.exist?(PDF_TEMP_RETURN_FILE)

        file_out.write(out)
        
      else
        print "[???]"
      end

      print " #{f}\n"
    end

    file_out.write("\n\n\n\n\n\n\n\n\n\n")
  }

  # close output file
  file_out.close
}
