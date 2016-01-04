require 'spec_helper'

describe DailyDigestJob do
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
