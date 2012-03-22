require 'spec_helper'

describe CpCreditsCalculator do
  describe "default values" do
    subject { CpCreditsCalculator }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
