require 'spec_helper'

describe CroppableAvatar do
  describe "default values" do
    subject { CroppableAvatar }
    it "should have crop_x" do
      subject.instance_methods.should include :crop_x
      subject.instance_methods.should include :crop_x=
    end
    it "should have crop_y" do
      subject.instance_methods.should include :crop_y
      subject.instance_methods.should include :crop_y=
    end
    it "should have crop_w" do
      subject.instance_methods.should include :crop_w
      subject.instance_methods.should include :crop_w=
    end
    it "should have crop_h" do
      subject.instance_methods.should include :crop_h
      subject.instance_methods.should include :crop_h=
    end
  end
end
