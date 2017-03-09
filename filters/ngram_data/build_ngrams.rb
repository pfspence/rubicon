#! /usr/local/bin/ruby

require "json"

class BrownCorpusFile
  def initialize(path)
    @path = path
  end

  def sentences(do_spaces)
    @sentences ||= File.open(@path) do |file|
      file.each_line.each_with_object([]) do |line, acc|
        stripped_line = line.strip

        unless stripped_line.nil? || stripped_line.empty?
          if do_spaces
            acc << line.split(' ').map do |word|
              word.split('/').first
            end.join(' ')
          else
            acc << line.split(' ').map do |word|
              word.split('/').first
            end.join('')
          end
        end
      end
    end

  end
end

class Corpus
  def initialize(glob, klass)
    @glob = glob
    @klass = klass
  end

  def files
    @files ||= Dir[@glob].map do |file|
      @klass.new(file)
    end
  end

  def sentences(do_spaces)
      files.map do |file|
        file.sentences(do_spaces)
      end.flatten
  end

  def ngrams(n, do_words, do_spaces, do_forward)
    sentences(do_spaces).map do |sentence|
      regex = do_words ? / / : //
      Ngrams.new(sentence, {regex: regex}).ngrams(n)
    end.flatten(1)
  end

  def unigrams
    ngrams(1, spaces)
  end

  def bigrams
    ngrams(2, spaces)
  end

  def trigrams
    ngrams(3, spaces)
  end
end

class Ngrams
  attr_accessor :options

  def initialize(target, options)
    @target = target
    @options = options
  end

  def ngrams(n)
    @target = @target.downcase.gsub(/-/i, ' ')
    @target = @target.downcase.gsub(/[^a-z0-9\s]/i, '')
    @target.split(@options[:regex]).each_cons(n).to_a
  end

  def unigrams
    ngrams(1)
  end

  def bigrams
    ngrams(2)
  end

  def trigrams
    ngrams(3)
  end
end

def build_ngrams()

  # N-Gram Builder
  # --------------------------------
  # input files [brown/c*]: 
  # words or letters? [words]: 
  # maintain spaces? [yes]: 
  # forward or reverse? [forward]: 
  # ngram length (2-5): 
  # output file [test.json]: 

  puts "N-Gram Builder"
  puts "-" * 80
  print "input files [brown/c*]: "
  input = gets.strip
  input_files = input.empty? || input == "brown/c*" ? "brown/c*" : input
  # No error checking on input_files so get it right.

  print "words or letters? [words]: "
  input = gets.strip
  while !(input.empty? || input == "words" || input == "letters")
    print "words or letters? [words]: "
    input = gets.strip
  end
  do_words = input.empty? || input == "words" 

  do_spaces = true
  if !do_words
    print "maintain spaces? [yes]: "
    input = gets.strip
    while !(input.empty? || input == "yes" || input == "no")
      print "maintain spaces? [yes]: "
      input = gets.strip
    end
    do_spaces = input.empty? || input == "yes" 
  end

  print "forward or reverse? [forward]: "
  input = gets.strip
  while !(input.empty? || input == "forward" || input == "reverse")
    print "forward or reverse? [forward]: "
    input = gets.strip
  end
  do_forward = input.empty? || input == "forward" 

  print "ngram length (2-5): "
  ngram_length = Integer(gets.strip) rescue nil
  while ngram_length.nil? || ngram_length > 5 || ngram_length < 2
    print "ngram length (2-5): "
    ngram_length = Integer(gets.strip) rescue nil
  end

  print "output file [test.json]: "
  input = gets.strip
  output_file = input.empty? || input == "test.json" ? "test.json" : input
  # No error checking here either, so don't mess up.

  #TODO: Show responses and verify

	corpus = Corpus.new(input_files, BrownCorpusFile)
	results = Hash.new
	# corpus.ngrams(ngram_length, do_spaces).each do |ngram|
  corpus.ngrams(ngram_length, do_words, do_spaces, do_forward).each do |ngram|
    
    ngram.map! do |el|
      el = el.downcase
    end 

    key = ngram[0..ngram_length-2].join(' ') # key construction will differ depending on ngram size
    if results[key].nil?
      results[key] = Hash.new(0)
    end

		results[key][ngram.join(' ')] += 1

	end

	File.open(output_file, 'w') do |f| 
		f.write results.to_json
	end
end

def score_bigram_letters(text)
  score_text(text, 'ngram_data/bigrams_letters.json')
end

def score_trigram_letters(text)
  score_text(text, 'ngram_data/trigrams_letters.json')
end

def score_fourgram_letters(text)
  score_text(text, 'ngram_data/fourgrams_letters.json')
end

def score_fivegram_letters(text)
  score_text(text, 'ngram_data/fivegrams_letters.json')
end

def score_text(text, file, ngram_length)
  # this needs to also shift the chunking and score
	text_arr = text.split('').each_cons(ngram_length).to_a
	trigrams = JSON.parse(File.read(file))  # Find way to keep this in memory
	total = 0

	text_arr.each do |letters|
		total += trigrams[letters.join('')] || 0
	end
	total
end

def flat_hash(hash, k = [])
  return {k => hash} unless hash.is_a?(Hash)
  hash.inject({}){ |h, v| h.merge! flat_hash(v[-1], k + [v[0]]) }
end

def gen_trigram_chains(ngrams, key0)
  chains = Hash.new
  ngram = ngrams[key0]
  chains[key0] = Hash.new

  ngram.keys.each do |key|
    key1 = key.split(' ')[1]
    if !key1.nil? && key1[/[a-z]+/] == key1
      ngram = ngrams[key1]
      chains[key0][key1] = Hash.new
      if !ngram.nil?
        ngram.keys.each do |key|
          key2 = key.split(' ')[1]
          chains[key0][key1][key2]= 0
        end
      end
    end
  end

  serialized = flat_hash(chains).keys.map do |key|
    key = key.join(' ')
  end
  serialized.to_a
end

def get_bigram_chains(ngrams, key0)
  ngram = ngrams[key0]
  ngram.keys.to_a
end

def get_chains()
  chains = []
  ngrams = JSON.parse(File.read("bigrams.json"))

  File.open("100_words_english.txt", "r") do |file|
    file.each_line do |line|
      puts line
      chains.concat get_bigram_chains(ngrams, line.strip)

    end
  end
  puts chains.length
end


# build_ngrams()
get_chains()
