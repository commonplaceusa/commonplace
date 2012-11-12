require 'spec_helper'

describe DailyDigestJob do
  describe "default values" do
    subject { DailyDigestJob }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end

  describe "#perform" do
    before do
      ResqueSpec.reset!
    end

    it "should enqueue some community daily bulletin jobs" do
      DailyDigestJob.perform
      CommunityDailyBulletinJob.should have_queue_size_of(Community.count)
    end
  end
end
