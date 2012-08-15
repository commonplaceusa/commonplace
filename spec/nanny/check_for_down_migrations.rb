describe "check for down migrations", :nanny => true do

  let(:files) do
    path = File.expand_path(File.join("..", "..", "db", "migrate", "*.rb"), File.dirname(__FILE__))
    Dir.glob(path)
  end

  it "should have a down migration for every up migration" do
    down_migration_errors = []
    files.map do |file|
      s = IO.read(file)
      next if s.index("def change")
      start_position = (s.index("self.down") || s.index("down"))
      if start_position
        end_position = s.rindex("end", s.rindex("end")-1)-1
        if s[start_position..end_position].gsub(/\s+/, "") == "self.down"
          down_migration_errors << "empty down migration for #{file.split('/').last}"
        end
      else
        down_migration_errors << "missing down migration for #{file.split('/').last}"
      end
    end
    down_migration_errors.should == []
  end
end
