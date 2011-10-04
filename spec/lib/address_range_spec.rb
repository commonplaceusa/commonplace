
describe AddressRange do

  context "when created with a single number" do
    subject { AddressRange.new("234") }

    specify "calling each yields just that number" do
      subject.each.to_a.should == [234]
    end
  end

  context "when created with a range of address numbers" do 
    context "without specifing a parity" do
      subject { AddressRange.new("1-30") }
      
      specify "calling each yields all the numbers in the range" do
        subject.each.to_a.should == (1..30).to_a
      end
    end

    context "specifing only even addresses" do
      subject { AddressRange.new("1-30E") }

      specify "calling each yields all the even numbers in the range" do
        subject.each.to_a.should == (1..30).select(&:even?)
      end
        
    end

    context "specifing only odd addresses" do
      subject { AddressRange.new("1-30O") }

      specify "calling each yields all the odd numbers in the range" do
        subject.each.to_a.should == (1..30).select(&:odd?)
      end

    end

  end

end
