require 'spec_helper'

describe HerokuResque::WorkerScaler do
  describe "default values" do
    subject { HerokuResque::WorkerScaler }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end

describe HerokuResque::WebScaler do
  describe "default values" do
    subject { HerokuResque::WebScaler }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
