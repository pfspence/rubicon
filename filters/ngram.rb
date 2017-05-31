require 'json'

class NgramScore
	attr_accessor :key
	attr_accessor :text
	attr_accessor :score
end

class Ngram

	def initialize(*args)
		@settings = Hash.new
		set_settings({"limit"=> "10"}) 
	end
	
	def set_settings(settings)
		unless settings.nil?
			if !settings['limit'].nil?
				@settings['limit'] = settings['limit']
			end
			if !settings['input'].nil?
				@settings['input'] = settings['input']
			end
		end
	end

	def process()
		result = Hash.new
		result['data'] = []
		result['metadata'] = []

		scores = []
		trigrams = JSON.parse(File.read('filters/ngram_data/trigrams_letters.json'))
		@settings['input']['data'].each_with_index do |datum, i|
			ngram_score = NgramScore.new
			ngram_score.instance_variable_set(:@text, datum)
			ngram_score.instance_variable_set(:@key, @settings['input']['metadata'][i])
			ngram_score.instance_variable_set(:@score, score_text(trigrams, datum))

			scores.push(ngram_score)
		end
		scores.sort_by! { |ngram_score| ngram_score.score }.reverse!
		# puts @settings.inspect, @settings['limit'], @settings['limit'].to_i
		scores = scores.take(@settings['limit'].to_i)
		# puts scores.inspect

		results = Hash.new
		results['data'] = []
		results['metadata'] = []
		scores.each do |score|
			results['data'].push(score.text)
			results['metadata'].push(score.key)
		end
		return results
	end

	def score_text(trigrams, text)
		text_arr = text.split('').each_cons(3).to_a
		total = 0
		text_arr.each do |letters|
			total += trigrams[letters.join('')] || 0
		end
		total
	end
end
