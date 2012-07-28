# require "spec_helper"

# describe StatisticsNetworkHealthCsvGenerator do
  # subject { StatisticsNetworkHealthCsvGenerator }
  # it "should define an end date for the statistics period" do
    # subject.end_date.should_be
  # end

  # it "should define a length of time" do
    # subject.days_elapsed.should_be
  # end

  # it "should define a filename" do
    # subject.filename.should_be
  # end

  # it "should enqueue an e-mail" do
    # subject.perform.should_enqueue Job
  # end

  # context "when the file already exists" do
    # before do
      # `touch #{subject.file_path}`
    # end
    # it "should remove the generated file" do
      # file_updated_time = File.ctime(subject.file_path)
      # subject.perform
      # new_file_updated_time = File.ctime(subject.file_path)
      # new_file_updated_time.should_not == file_updated_time
    # end

  # end
# end
