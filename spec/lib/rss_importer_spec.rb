require 'spec_helper'

describe RssImporter do
  describe "default values" do
    subject { RssImporter }
    its(instance_variable_get("@queue")) { should_not be_nil }
  end
  # TODO: Test perform
end
