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
    expect(Community.count).to eq 4
    expect(User.count).to eq 12
  end

  describe "Running the job" do
    it "should enqueue DailyDigestJob" do
      Resque.enqueue(DailyDigestJob)
      expect(DailyDigestJob).to have_queue_size_of(1)
    end

    it "should enqueue multiple community jobs" do
      DailyDigestJob.perform

      CommunityDailyBulletinJob.should have_queue_size_of(Community.count)
    end

    it "should enqueue lots of specific daily bulletins" do
      [
        community_1,
        community_2,
        community_3,
        community_4,
      ].each do |community|
        CommunityDailyBulletinJob.perform(community.id, DateTime.current.to_s)
      end

      DailyBulletin.should have_queue_size_of(User.count)
    end
  end
end
