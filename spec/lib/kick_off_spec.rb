require 'spec_helper'
describe KickOff do
  let(:resque) { Object.new }
  let(:kickoff) { KickOff.new(resque) }

  describe "#deliver_user_message" do
    let(:message) {
      stub(Message.new) do |m|
        stub(m).id { 64 }
        stub(m).messagable_id { 12 }
      end
    }

    it "queues a MessageNotification job" do
      mock(resque).enqueue(MessageNotification, 64, 12)
      kickoff.deliver_user_message(message)
    end
  end

  describe "#deliver_group_post" do 
    let(:post) {
      stub(GroupPost.new) do |p|
        stub(p).user_id { 5 }
        stub(p).id { 3414 }
        stub(p).group.stub!.live_subscribers.stub!.map { [1,2,3,4,5] }        
      end
    }

    it "queues a GroupPostNotification subscribers of the group" do
      (1..4).each do |id| 
        mock(resque).enqueue(GroupPostNotification, 3414, id)
      end
      kickoff.deliver_group_post(post)
    end

    it "doesn't queue a GroupPostNotification for the poster" do
      mock(resque).enqueue(GroupPostNotification, 3414, 1..4)
      mock(resque).enqueue(GroupPostNotification, 3414, 5).times(0)
      kickoff.deliver_group_post(post)
    end
  end

end
