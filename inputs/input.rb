class Input
	attr_accessor :settings

	def initialize(args)
		@settings = Hash.new
		set_settings({"input"=> args })  
	end																						
																							
	def set_settings(settings)																
		if !settings.nil?																	
			if !settings['input'].nil?	
				#This whole shit is a one off.
				data = (settings['input'].is_a? String) ? [settings['input']] : settings['input'] 													
				@settings['input'] = {"data"=> data, "metadata"=>[]} 
			end
		end
	end

	def process()
		return @settings['input']
	end
end