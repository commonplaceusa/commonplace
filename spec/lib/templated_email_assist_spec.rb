require 'spec_helper'

describe TemplatedEmailAsset do
  let(:email_asset) { TemplatedEmailAsset.new }
  describe "default values" do
    it "has a bucket name" do
      email_asset.should_not be_nil
    end
    it "has a background color" do
      email_asset.background_color.should_not be_nil
    end
    # TODO: Test erb_template
    # TODO: Test to_svg
    # TODO: Test to_png
    # TODO: Test upload!
  end
end
