require 'spec_helper'

describe CommunityDailyBulletinJob do
  describe "default values" do
    it "has a queue specified" do
      expect(CommunityDailyBulletinJob.instance_variable_get("@queue")).not_to be_nil
    end
  end

  describe "#perform" do
    before do
      ResqueSpec.reset!
    end

    it "should enqueue the right number of e-mails" do
      total_sent = 0
      Community.find_each do |c|
        ResqueSpec.reset!
        CommunityDailyBulletinJob.perform(c, DateTime.now.to_s(:db))
        DailyBulletin.should have_queue_size_of(c.users.where("post_receive_method != 'Never'").count)
        total_sent += ResqueSpec.queue_for(DailyBulletin).size
      end

      total_sent.should == User.where("post_receive_method != 'Never'").count
    end
  end
end
