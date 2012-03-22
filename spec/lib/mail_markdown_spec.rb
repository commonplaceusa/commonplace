require 'spec_helper'

describe MailMarkdown do
  let(:raw_text) { "TextToBeWrapped" }
  subject { MailMarkdown.new.paragraph(raw_text) }
  it { should == '<div class="p">' + raw_text + '</div>
' }
end
