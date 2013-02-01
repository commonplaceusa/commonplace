require "spec_helper"

describe "The bundler Gemfile", :nanny => true do
  let(:gemfile_contents) { File.read(Rails.root.join("Gemfile")) }

  describe "the contents" do
    it "should use hashrock syntax only" do
      gemfile_contents.split("\n").each do |line|
        fail(line) if line=~ /\s(require|git|version|branch|path):\s/
      end
    end
    it "should only reference public git urls so deploys do not break" do
      gemfile_contents.split("\n").each do |line|
        fail(line) if line=~ /@github.com/
      end
    end

    it "should contain exact version numbers for all gems" do
      gemfile_contents.split("\n").select { |l| l.include? 'gem "' or l.include? "gem '" }.each do |line|
        fail(line) unless line =~ /(["']= (.*)["']|ref)/
      end
    end
  end
end
