desc 'List all step definitions'
task :steps do

  # # let's collect all steps in this hash, grouped by source file
  # $steps = {}

  # module Cucumber
  #   class StepDefinition
  #     # let's override the step constructor to 
  #     # capture the necessary information
  #     alias_method :old_initialize, :initialize
  #     def initialize(regexp, &proc)
  #       caller[1] =~/.+\/(.+)\./
  #       $steps[$1] ||= []
  #       $steps[$1] << regexp.to_s[8..-3]
  #       old_initialize(regexp, &proc)
  #     end
  #   end
  # end

  # # require the files containing the step definitions,
  # # so they get all instantiated and captured
  # require "action_mailer"
  # require "cucumber"
  # require "pickle"
  # require "pickle/world"
  # require 
  # require 
  # require 
  # require 

  # # printing out results
  # $steps.keys.sort.each do |file|
  #   puts file + ":"
  #   $steps[file].sort.each { |s| puts "  " + s }
  #   puts
  # end


[ "#{RAILS_ROOT}/features/step_definitions/email_steps.rb",
"#{RAILS_ROOT}/features/step_definitions/steps.rb",
"#{RAILS_ROOT}/features/step_definitions/web_steps.rb",
"#{RAILS_ROOT}/features/step_definitions/pickle_steps.rb",
].each do |support_file|
  File.new(support_file).read.each_line do |line|
    next unless line =~ /^\s*(?:Given|When|Then)\s+\//
      matches = /(Given|When|Then)\s*\/(.*)\/([imxo]*)\s*do\s*(?:$|\|(.*)\|)/.match(line).captures
#      matches[0] = Regexp.new(matches[0])

      puts "\"#{matches[0]} #{matches[1]}\"\t\"#{matches[3] || "none"}\""
    end
  end
end







