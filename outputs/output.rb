class Output
	attr_accessor :settings

	def initialize(input)
		@settings = Hash.new
		set_settings({"input"=> { 'data'=>[], 'metadata'=>[] }}) 
	end
	def set_settings(settings)
		unless settings.nil?
			if !settings['input'].nil?
				@settings['input'] = settings['input']
			end
		end
	end

	def process()
		return @settings['input']
	end
end