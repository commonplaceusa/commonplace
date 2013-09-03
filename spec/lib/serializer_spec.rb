require 'spec_helper'

describe Serializer do
  describe ".serialize" do
    subject { Serializer.serialize(serializable) }
    let(:community) { FactoryGirl.create(:community, neighborhoods: [neighborhood]) }
    let(:neighborhood) { FactoryGirl.create(:neighborhood) }
    let(:owner) { FactoryGirl.create(:user, community: community) }

    context "when the serializable content is malformed" do
      let(:serializable) {
        FactoryGirl.create(:transaction, community: community, owner: owner)
      }

      before do
        serializable.owner = nil
      end

      it "should not raise an exception" do
        expect { subject }.not_to raise_exception
      end
    end
  end
end
