require 'spec_helper'

describe EmailCountResetter do
  describe "default values" do
    subject { EmailCountResetter }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
