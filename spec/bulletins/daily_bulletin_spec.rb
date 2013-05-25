require 'spec_helper'

describe "Daily Bulletins" do
  let!(:community_1) { FactoryGirl.create(:community, slug: "test") }
  let!(:community_2) { FactoryGirl.create(:community, slug: "test2") }
  let!(:community_3) { FactoryGirl.create(:community, slug: "test3") }
  let!(:community_4) { FactoryGirl.create(:community, slug: "test4") }
  let!(:user1) { FactoryGirl.create(:user, community: community_1, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_1.id)) }
  let!(:user2) { FactoryGirl.create(:user, community: community_1, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_1.id)) }
  let!(:user3) { FactoryGirl.create(:user, community: community_1, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_1.id)) }
  let!(:user4) { FactoryGirl.create(:user, community: community_1, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_1.id)) }
  let!(:user5) { FactoryGirl.create(:user, community: community_2, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_2.id)) }
  let!(:user6) { FactoryGirl.create(:user, community: community_2, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_2.id)) }
  let!(:user7) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  let!(:user8) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  let!(:user9) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  let!(:user10) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  let!(:user11) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  let!(:user12) { FactoryGirl.create(:user, community: community_3, neighborhood: FactoryGirl.create(:neighborhood, community_id: community_3.id)) }
  before do
    Community.count.should == 4
    User.count.should == 12
    RspecResque.reset!
    Resque.enqueue(DailyDigestJob);
  end
  describe "Running the job" do
    it "should enqueue DailyDigestJob" do
      DailyDigestJob.should have_queue_size_of(1)
    end

    it "should enqueue multiple community jobs" do
      run_resque(:daily_digest)
      CommunityDailyBulletinJob.should have_queue_size_of(Community.count)
    end

    it "should enqueue lots of specific daily bulletins" do
      run_resque(:daily_digest)
      run_resque(:community_daily_bulletin)
      DailyBulletin.should have_queue_size_of(User.count)
    end

  end

end
