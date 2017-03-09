# This generally serves as a template, although, it might have some use for redirecting input output.

class Passthru
	attr_accessor :settings

	def initialize(*args)
		@settings = Hash.new
		set_settings({"foo"=>"bar", "input"=> { 'data'=>[], 'metadata'=>[] }})
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
		return @settings['input']
	end
end