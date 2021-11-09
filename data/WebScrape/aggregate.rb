#!/usr/bin/env ruby

# 
# Counts words in 
#  ARGV[0]/university name.txt
# and merges with the previous CSV
#

IN_CSV = '../WebList/weblist.csv'
OUT_CSV = '../uni_wordlist.csv'
HEADERS = %w(id word word_freq uni_total_freq stem uni_id uni url)

require 'csv'
require './porter_stemmer.rb'

if ARGV.length < 1 then
  puts "ARGument required: path to folder of scraped stuff."
  exit(1)
end

# ------------------------------------------------------------------


# Split text into words.
# TODO: make less shit, more linguistically strict
def segment(text)
  text.encode!('UTF-8', 'UTF-8')

  # remove apostrophes for simplicity
  text.gsub("'", '')

  # split by non-alphanum
  candidates = text.split /[^a-zA-Z]/

  # remove some tiny quirks
  candidates.delete_if{|c|
    c.length < 1 or
    c == 'o' or # o is used as formatting by the converter script
    (c.length == 1 and c != 'a') # other single-char nonsensical things
  }

  return candidates
end

# normalise words into a standard, comparable format.
def normalise(words)
  words.map{|w|
    w.to_s.strip.downcase
  }
end

# build a frequency table from an array
def build_freq(words)
  Hash[
    words.group_by{|x|x}.map{|k,v|
      [k,  v.length]
    }
  ]
end


# ------------------------------------------------------------------

# Load url data from old csv
unis = {}
uni_id = 0
CSV.foreach(IN_CSV, :headers => true){|cin|
  unis[cin.field('uni')] = {:url => cin.field('url'), :uni_id => uni_id}
  uni_id += 1
}

puts "Loaded #{unis.length} universities"


# ------------------------------------------------------------------

# now go through each txt file, strip, count words and add to csv
cout = CSV.open(OUT_CSV, 'w')

# write headers
cout << HEADERS

# count line id
id = 0

Dir.glob(File.join(ARGV[0], "*")){|f|
  if not File.directory?(f) and File.extname(f) == '.txt' then
    # load
    txt = File.read(f)
    # identify uni
    uni = File.basename(f).to_s[0..-(File.extname(f).length+1)]

    puts "uni -> #{uni} (#{unis.include?(uni)})"

    # strip
    words = segment(txt)

    # normalise 
    words = normalise(words)

    # count
    freq_table = build_freq(words)

    # output
    freq_table.each{|word, freq|
      # puts "--> #{freq} : #{word}"

      # HEADERS = %w(id word word_freq uni_total_freq stem uni uni_id uni url)
      cout << [id, word, freq, words.length, word.stem, unis[uni][:uni_id], uni, unis[uni][:url]]
    
      # inc line id
      id += 1
    }

  end
}




cout.close
