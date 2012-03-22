require 'spec_helper'

describe CommunityDailyBulletinJob do
  describe "default values" do
    subject { CommunityDailyBulletinJob }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
