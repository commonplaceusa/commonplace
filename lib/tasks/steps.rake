desc 'List all step definitions'
task :steps do

["#{RAILS_ROOT}/features/step_definitions/email_steps.rb",
"#{RAILS_ROOT}/features/step_definitions/steps.rb",
"#{RAILS_ROOT}/features/step_definitions/web_steps.rb",
"#{RAILS_ROOT}/features/step_definitions/pickle_steps.rb",
].each do |support_file|
  File.new(support_file).read.each_line do |line|
    next unless line =~ /^\s*(?:Given|When|Then)\s+\//
      matches = /(Given|When|Then)\s*\/(.*)\/([imxo]*)\s*do\s*(?:$|\|(.*)\|)/.match(line).captures
      puts "\"\"#{matches[0]} #{matches[1]}\"\",\"\"#{matches[3] || "none"}\"\""
    end
  end
end







