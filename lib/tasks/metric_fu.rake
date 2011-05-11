begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.rcov[:test_files] = ['spec/**/*_spec.rb']
    config.rcov[:rcov_opts] << "-Ispec development/ruby/1.8/bin/spec -- spec/**/*_spec.rb --format silent" # Needed to find spec_helper
  end   
rescue LoadError
end                    
