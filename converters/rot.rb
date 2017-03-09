# modlule rot.rb
class Rot
	attr_accessor :settings

	def initialize(*args)
		@settings = Hash.new
		set_settings({"key"=> "all", "input"=> { 'data'=>[], 'metadata'=>[] }}) #default rot 13
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
		data = []
		metadata =[]
		if !@settings['key'].nil? && @settings['key'] == 'all'
			key_range = (0..25).to_a
		else 
			key_range = @settings['key']
		end
		@settings['input']['data'].each do |input|
			if key_range.is_a? Array
				key_range.each do |key|
					data.push(rotate(input, key))
					metadata.push(key.to_s)
				end
			else
				key = (key_range.is_a? String) ? key_range.to_i : key_range
				data.push(rotate(input, key))
				metadata.push(key.to_s)
			end
		end
		result = Hash.new
		result['data'] = data
		result['metadata'] = metadata 
		return result
	end

	def rotate(text, key)
		letters = ('a'..'z').to_a
		letters_cap = ('A'..'Z').to_a
		textArr = text.split('')
		textArr.map! do |letter|
			if letters.include?(letter) 
				index = letters.find_index(letter)
				letters[(index + key) % letters.size]
			elsif letters_cap.include?(letter) 
				index = letters_cap.find_index(letter)
				letters_cap[(index + key) % letters_cap.size]
			else
				letter = letter
			end
				
		end
		return textArr.join('')
	end

end