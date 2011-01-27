require 'spec_helper'

describe IDEncoder do

  describe "Base64 Encoding/Decoding" do
    before :each do 
    end

    it "should successfully handle Base64 encoding and decoding" do
      (1..10000).each do |n|
        IDEncoder.from_long_id(IDEncoder.to_long_id(n)).to_i.should == n
      end
    end
  end
end
