class Vigenere
	attr_accessor :settings

	def initialize(*args)
		@settings = Hash.new
		set_settings({"key"=>["HO"], "input"=> { 'data'=>[], 'metadata'=>[] }})
	end

	def set_settings(settings)
		unless settings.nil?
			if !settings['key'].nil?
				@settings['key'] = settings['key']
			end
			if !settings['input'].nil?
				@settings['input'] = settings['input']
			end
		end
	end

	def process()
		alphabet = ('a'..'z').to_a
		grid_alphabet = []
		grid_alphabet.push(alphabet.join());
		25.times do
			alphabet.push(alphabet.shift)
			grid_alphabet.push(alphabet.join())
		end

		puts grid_alphabet.inspect
		key = (@settings['key'].is_a? Array) ? @settings['key'] : [@settings['key']]
		text =  @settings['input']['data']

		output = Hash.new
		output['data'] = []
		output['metadata'] = []

		key.each do |k|
			text.each do |t|
				translated = []
				t.size.times do |i|
					x = alphabet.index(t[i].downcase)
					y = alphabet.index(k[i%k.size].downcase)
					puts x.to_s + " " + y.to_s
					translated.push(grid_alphabet[x][y])
				end
				output['data'].push(translated.join())
				output['metadata'].push(k + " " + t)
			end
		end
		return output
	end
end