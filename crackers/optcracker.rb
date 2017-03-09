# modlule rot.rb

class Otpcracker
	# thequickbrownfoxjumpedoverthelazydog
	# myvoiceismypassportmyvoiceismypasspo
	# ffzeckgstdmlnxgmxlfbcycdgvbzqjpzqvdu

	def initialize(input)
		@input = input
		@letters = ('a'..'z').to_a.join('')

	end
	def set_options(*options)
		#seed_file ?
	end

	def process()
		ngrams = JSON.parse(File.read('filters/ngram_data/fivegrams_nospaces.json'))
		keyScores = []
		plainScores = []
		n = 5

		num_ngrams = @input[0].size / n

		puts "  " + decrypt_string(@input[0], "myvoiceismypassportmyvoiceismypasspo")

	    100.times do
	    	chain = []

			num_ngrams.times do
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				chain.push(ngram.keys.first)
			end
			while chain.join('').size < @input[0].size
				chain.push('a')
			end
			gen_string = chain.join('')
		# gen_string[0..gen_string.size-n].each_char.with_index do |letter, i|
		# 	keyScores[i] = ngrams[gen_string[i...i+n]] || 0
		# 	plain_ngram = decrypt_ngram(@input[0], gen_string[i...i+n], i, n)
		# 	plainScores[i] = ngrams[plain_ngram] || 0
		# end

			keytxt_hiscore = score_text(ngrams, gen_string, n)
			plntxt_hiscore = score_text(ngrams, decrypt_string(@input[0], gen_string), n)

			iterations = 100
			report_at = iterations / 10 	# Report every 10%
			iterations.times do |time|
				if time % report_at == 0 && time != 0
					# puts (time.to_f / iterations * 100).to_i.to_s + '%'
				end
				i = rand(gen_string.size)
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				plain_ngram = decrypt_ngram(@input[0], ngram.keys.first, i, n)
				plain_score = ngrams[plain_ngram] || 0
				# if (ngram.values.first > keyScores[i] && plain_score > plainScores[i])

				keytxt_score = score_text(ngrams, gen_string, n)
				plntxt_score = score_text(ngrams, decrypt_string(@input[0], gen_string), n)
				if keytxt_score > keytxt_hiscore && plntxt_score > plntxt_hiscore
					keytxt_hiscore = keytxt_score
					plntxt_hiscore = plntxt_score
					gen_string[i...i+n] = ngram.keys.first
					# keyScores[i] = ngram.values.first
					# plainScores[i] = plain_score
				end
			end
			puts gen_string
			puts decrypt_string(@input[0], gen_string)
			puts ""
		end

		puts "*" * 80 

		100.times do
	    	chain = []

			num_ngrams.times do
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				chain.push(ngram.keys.first)
			end
			while chain.join('').size < @input[0].size
				chain.push('a')
			end
			gen_string = chain.join('')
		# gen_string[0..gen_string.size-n].each_char.with_index do |letter, i|
		# 	keyScores[i] = ngrams[gen_string[i...i+n]] || 0
		# 	plain_ngram = decrypt_ngram(@input[0], gen_string[i...i+n], i, n)
		# 	plainScores[i] = ngrams[plain_ngram] || 0
		# end

			keytxt_hiscore = score_text(ngrams, gen_string, n)
			plntxt_hiscore = score_text(ngrams, decrypt_string(@input[0], gen_string), n)

			iterations = 1000
			report_at = iterations / 10 	# Report every 10%
			iterations.times do |time|
				if time % report_at == 0 && time != 0
					# puts (time.to_f / iterations * 100).to_i.to_s + '%'
				end
				i = rand(gen_string.size)
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				plain_ngram = decrypt_ngram(@input[0], ngram.keys.first, i, n)
				plain_score = ngrams[plain_ngram] || 0
				# if (ngram.values.first > keyScores[i] && plain_score > plainScores[i])

				keytxt_score = score_text(ngrams, gen_string, n)
				plntxt_score = score_text(ngrams, decrypt_string(@input[0], gen_string), n)
				if keytxt_score > keytxt_hiscore && plntxt_score > plntxt_hiscore
					keytxt_hiscore = keytxt_score
					plntxt_hiscore = plntxt_score
					gen_string[i...i+n] = ngram.keys.first
					# keyScores[i] = ngram.values.first
					# plainScores[i] = plain_score
				end
			end
			puts gen_string
			puts decrypt_string(@input[0], gen_string)
			puts ""
		 end

		 puts "*" * 80 

		20.times do
	    	chain = []

			num_ngrams.times do
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				chain.push(ngram.keys.first)
			end
			while chain.join('').size < @input[0].size
				chain.push('a')
			end
			gen_string = chain.join('')
		# gen_string[0..gen_string.size-n].each_char.with_index do |letter, i|
		# 	keyScores[i] = ngrams[gen_string[i...i+n]] || 0
		# 	plain_ngram = decrypt_ngram(@input[0], gen_string[i...i+n], i, n)
		# 	plainScores[i] = ngrams[plain_ngram] || 0
		# end

			keytxt_hiscore = score_text(ngrams, gen_string, n)
			plntxt_hiscore = score_text(ngrams, decrypt_string(@input[0], gen_string), n)

			iterations = 10000
			report_at = iterations / 10 	# Report every 10%
			iterations.times do |time|
				if time % report_at == 0 && time != 0
					# puts (time.to_f / iterations * 100).to_i.to_s + '%'
				end
				i = rand(gen_string.size)
				ngram = ngrams.to_a.sample(1).to_h
				while ngram.keys.first[/[a-z]+/] != ngram.keys.first
					ngram = ngrams.to_a.sample(1).to_h
				end
				plain_ngram = decrypt_ngram(@input[0], ngram.keys.first, i, n)
				plain_score = ngrams[plain_ngram] || 0
				# if (ngram.values.first > keyScores[i] && plain_score > plainScores[i])

				keytxt_score = score_text(ngrams, gen_string, n)
				plntxt_score = score_text(ngrams, decrypt_string(@input[0], gen_string), n)
				if keytxt_score > keytxt_hiscore && plntxt_score > plntxt_hiscore
					keytxt_hiscore = keytxt_score
					plntxt_hiscore = plntxt_score
					gen_string[i...i+n] = ngram.keys.first
					# keyScores[i] = ngram.values.first
					# plainScores[i] = plain_score
				end
			end
			puts gen_string
			puts decrypt_string(@input[0], gen_string)
			puts ""
		 end

		return []
	end

	def score_text(ngrams, text, n)
		text_arr = text.split('').each_cons(n).to_a
		# trigrams = JSON.parse(File.read('ngram_data/trigrams.json'))
		total = 0

		text_arr.each do |letters|
			total += ngrams[letters.join('')] || 0
		end
		total
	end

	def decrypt_string(input, key)
		plain_text = []
		input.each_char.with_index do |letter, i|
			letter_val = @letters.index(letter)
			key_val = @letters.index(key[i])
			plain_val = (letter_val - key_val) % @letters.size
			plain_text.push @letters[plain_val]
		end
		return plain_text.join('')
	end

	def decrypt_char(input_char, key_char)
		letter_val = @letters.index(input_char)
		key_val = @letters.index(key_char)
		plain_val = (letter_val - key_val) % @letters.size
		return @letters[plain_val]
	end

	def decrypt_ngram(input, key, index, n)
		plain_text = []
		input[index...index+n].each_char.with_index do |letter, i|
			letter_val = @letters.index(letter)
			key_val = @letters.index(key[i])
			plain_val = (letter_val - key_val) % @letters.size
			plain_text.push @letters[plain_val]
		end
		return plain_text.join('')
	end
end