require 'spec_helper'

describe Community do

  describe "when asked for a neighborhood for an address" do
    
    let(:community) { 
      mock_model(Community, :neighborhoods => neighborhoods, :zip_code => "02139")
    }

    let(:neighborhoods) { 
      Array.new(4) { mock_model(Neighborhood, :contains? => false) } 
    }
    
    it "should return the first neighborhood when the address isn't found" do
      stub(LatLng).from_address { nil }
      community.neighborhood_for("not an address").should be(neighborhoods.first)
    end

    it "should return the first neighborhood when the no neighborhoods match" do
      stub(LatLng).from_address { true }
      community.neighborhood_for("some address").should be(neighborhoods.first)
    end

    it "should return the first neighborhood that does match" do
      stub(neighborhoods[2]).contains? { true }
      stub(LatLng).from_address { true }
      community.neighborhood_for("some address").should be(neighborhoods[2])
    end

  end

end
