#! /usr/local/bin/ruby
require "colorize"
require 'readline'
require 'ascii_charts'
require 'terminfo'
require "./processor_template.rb"
require "./analytics/analitics_data/number_constants.rb"
require "./analytics/analitics_data/alpha_constants.rb"

class Rubicon
	# all humans are born free and equal in dignity and rights
	# nyy uhznaf ner obea serr naq rdhny va qvtavgl naq evtugf

	def initialize()
		@processor_names = ['inputs', 'generators', 'converters', 'filters', 'outputs', 'analytics']
		@state = Hash.new
		@modules = Hash.new
		@processor_names.each do |processor_name|
			@state[processor_name] = []
			@modules[processor_name] = {
				'dir' => "./#{processor_name}/*.rb",
				'names' => []
			}
		end
		@modules.each_pair {|key, value| 
			value['names'] = Dir[value['dir']].each {|file| require file}
			value['names'].map! {|filename| File.basename(filename, ".rb")}
		}

	end

	def set(*args)
		@processor_names.each do |processor_type|
			@state[processor_type].each do |processor| 
				if processor.instance_variable_get(:@instance) == args[0]
					settings = split_settings(args[1..-1])
					processor.instance_variable_set(:@settings, settings)
					return true
				end
			end
		end
		puts_error(args[0] + " <--- Not a valid instance name. Did you mean " + args[0] + "_0?")
		return false
	end

	def add(*args)
		@processor_names.each do |processor_type|
			if args.length > 0 && (@modules[processor_type]['names'].include? args[0])
				processor_template = ProcessorTemplate.new
				instance_number = @state[processor_type].count { |h| h.instance_variable_get(:@name) == args[0] }
				processor_template.instance_variable_set(:@name, args[0])
				processor_template.instance_variable_set(:@instance, args[0] + '_' + instance_number.to_s)
				processor_template.instance_variable_set(:@additional_args, args[1..-1])
				@state[processor_type].push(processor_template)
				return true
			end
		end
		puts_error(args[0] + " <--- Processor not found. Try \"list processors\"")
		return false
	end

	def remove(instance_name)
		@processor_names.each do |processor_type|
			@state[processor_type].delete_if { |h| h.instance_variable_get(:@instance) == instance_name }
		end
	end

	def show(*args)
		def state

			# 1. Create instance from template
			# 2. Set settings and input
			# 3. Process (validate output)
			# 4. Set outputs
			# 5. Print
			@state['outputs'] = []
			@state['inputs'].each_with_index do |input, index|
				add('output')
			end
			print_header((TermInfo.screen_size[1] -1))
			@state.each do |key, templates|
				if templates.length > 0
					print_processor_header(key,(TermInfo.screen_size[1] -1))

					templates.each_with_index do |template, index|
						#TODO: put all the attrs onto the instance so we don't need to keep passing the template along with the instance into methods.
						instance = create_instance(template)
						configure_instance(instance, template)

						output = instance.process()
						is_output_valid(template.instance_variable_get(:@name), output)
						set_outputs(template, output)

						print_processor(instance, template, (TermInfo.screen_size[1] -1))
					end
					puts ""
				end
			end
			return true
		end
		
		if self.respond_to?(args[0])
			return self.send(args[0])
		else
			return false
		end
	end
	
	def run()
		show('state')
	end

	def list(*arg)

		if arg.length > 0 && (@modules.has_key? arg[0])
			puts ""
			puts arg[0]
			puts "-" * 40
			puts @modules[arg[0]]['names']
			puts ""
		else
			puts ""
			puts "available commands:"
			puts "-" * 40
			@modules.each_pair {|key, value| puts 'list ' +  key}
			puts ""
		end
	end

	# Helper functions. To be made private
	def split_command(command)
		command_strings = command.split(/\"/)
		command_args = []
		command_strings.each_with_index { |command, index| 
			if index.even? 
				commands = command.split(/\s/)
				command_args.push(*commands)
			else
				command_args.push(command)
			end
		}
		return command_args
	end
	def split_settings(args)
		args.map! do |arg|
			arg = arg.split("=")
		end
		settings = args.to_h

		return settings
	end
	def is_output_valid(name, output)
		is_hash = output.is_a? Hash 
		if !is_hash
			return puts_error("#{name} <--- Processor output is not a Hash", output)
		end
		
		contains_keys = (output.key?('data') && output.key?('metadata'))
		if !contains_keys
			return puts_error("#{name} <--- Processor output does not contain keys 'data' and 'metadata'", output)
		end

		values_are_arrays = (output['data'].is_a? Array) && (output['metadata'].is_a? Array)
		if !values_are_arrays 
			return puts_error("#{name} <--- Processor output 'data' and 'metadata' do not contain Arrays", output)
		end

		true
	end

	def puts_error (text, element=nil)
		puts text.red
		if !element.nil? 
			puts element.inspect 
		end
		false
	end

	def create_instance(processor_template)
		processor_class = Object.const_get(processor_template.instance_variable_get(:@name).capitalize)
		return processor_class.new(processor_template.instance_variable_get(:@additional_args))
	end
	def configure_instance(processor_instance, processor_template) 
		# puts processor_instance.inspect, processor_template.inspect
		settings = processor_template.instance_variable_get(:@settings) || {}
		settings.each do |key, val|
			if val[0] == ">" || val[0] == "*"
				instance_ref = val[1..-1]
				instance = @state.values.flatten.find {|inst| inst.instance_variable_get(:@instance) == instance_ref}
				if !instance.nil?
					input = Hash.new
					input['data'] = instance.instance_variable_get(:@data)
					input['metadata'] = instance.instance_variable_get(:@metadata)
					settings[key] = key == 'input' ? input : input['data']
				end
			else
				settings[key] = val 
			end
		end
		if settings['input'].nil? && (processor_template.instance_variable_get(:@name) != 'input')
			input = Hash.new
			input['data'] = @state['outputs'][0].instance_variable_get(:@data)
			input['metadata'] = @state['outputs'][0].instance_variable_get(:@metadata)
			settings['input'] = input
		end
		processor_instance.set_settings(settings)
	end

	def set_outputs(processor_template, output)
		@state['outputs'][0].instance_variable_set(:@data, output['data'].clone)
		@state['outputs'][0].instance_variable_set(:@metadata, output['metadata'].clone)
		processor_template.instance_variable_set(:@data, output['data'].clone)
		processor_template.instance_variable_set(:@metadata, output['metadata'].clone)
	end

	def print_processor(processor_instance, processor_template, full_w)
		half_w = full_w / 2
		quarter_w = full_w / 4
		tab = 3

		line = "#{processor_template.instance_variable_get(:@instance)} ( "
		unless processor_instance.instance_variable_get(:@settings).nil?
			processor_instance.instance_variable_get(:@settings).each do |setting_key, setting_value|
				unless setting_key == 'input' # Showing the input in the settings creates too much noise
					line += "#{setting_key}:#{setting_value} "
				end
			end
		end
		line += ")"
		print line + "\n"

		limit = processor_template.instance_variable_get(:@name) == "analytics" || processor_template.instance_variable_get(:@name) == "output" ? - 1 : 3
		processor_template.instance_variable_get(:@data)[0..limit].each_with_index do |data, index|
			col1 = " " * tab 
			unless processor_template.instance_variable_get(:@metadata).nil? || processor_template.instance_variable_get(:@metadata)[index].nil?
				col1 += processor_template.instance_variable_get(:@metadata)[index][0..half_w-tab] 
			end
			col2 = " " * (half_w - col1.size) + data[0..half_w]
			print col1 + col2 + "\n"
		end
	end

	def print_header(full_w)
		half_w = full_w / 2
		puts "=".red * full_w
		puts "SETTINGS/METADATA".red  + " " * (half_w - 17) + "OUTPUT".red
		puts "=".red * full_w
	end

	def print_processor_header(name, full_w)
		half_w = full_w / 2
		puts "#{name}" 
		puts "-" * (half_w - 4) + " " * 4 + "-" * half_w 
	end

end

rubicon = Rubicon.new()

puts "-" * (TermInfo.screen_size[1] -1)
puts "Welcome \n\n"
line = ''

LIST = [
	'set',  
	'add', 'add analytics', 'add sequencer', 'add rot', 'add vigenere', 
	'show', 'show state', 
	'list', 
	'run', 'remove'
	].sort

comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }

Readline.completion_append_character = " "
Readline.completer_word_break_characters = "" #Pass whole line to proc each time
Readline.completion_proc = comp

while line = Readline.readline('> ', true)
	if line == "exit" || line == "quit"
		break
	end
	unless line.empty?
		command_args = rubicon.split_command(line)
		basecommand = command_args[0]
		if rubicon.respond_to?(basecommand)  
		  rubicon.send(basecommand, *command_args[1..-1])
		else
			puts basecommand + ' <--- invalid command'.red
		end 
	end
end
