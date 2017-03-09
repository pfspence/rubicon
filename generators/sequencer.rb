class Sequencer
	attr_accessor :settings

	def initialize(args)
		set_settings({"key"=> "foobar"})
	end
	def set_settings(settings)
		@settings = settings
	end

	def process()
		data = []
		metadata =[]

		data = ["10","11","12","13","14","15"]

		result = Hash.new
		result['data'] = data
		result['metadata'] = []
		return result
	end
end