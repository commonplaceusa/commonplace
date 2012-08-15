require "spec_helper"

describe "Resque Scheduler", :nanny => true do

  it "should not list classes that do not exist" do
    schedule = YAML.load(File.read(Rails.root.join("config/resque_schedule.yml")))
    schedule.each do |job, hash|
      begin
        hash["class"].constantize
      rescue NameError => e
        fail "#{hash['class']} does not exist but is referenced in config/resque_schedule.yml!"
      end
    end
  end
end

