require 'spec_helper'

describe DailyDigestJob do
  describe "default values" do
    subject { DailyDigestJob }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
