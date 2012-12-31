class KissmetricsDumpDownload
  @queue = :statistics

  def self.perform
    require 'net/http'
    require 'rexml/document'

    `rm -rf km_dump`
    `mkdir km_dump`

    conn = {
      access_key_id: ENV['EC2_KEY_ID'],
      secret_access_key: ENV['EC2_KEY_SECRET']
    }

    AWS::S3::Base.establish_connection!(conn)

    bucket = AWS::S3::Bucket.find("cpkissmetrics")
    files = [bucket['index.csv']]

    files.each do |obj|
      filename = obj.key.gsub("/", "_")
      File.open("km_dump/#{filename}", 'w') { |f| f.write(obj.value) }
      puts "Processed #{filename}"
    end

    unless File.exists? 'km_dump/index.csv'
      raise "Did not download index manifest. Aborting..."
    end

    index_file = File.read('km_dump/index.csv').split("\n")
    index_file.shift(1)

    index_file.each do |index_file_line|
      original_filename = index_file_line.split(",").first
      filename = original_filename.gsub("/", "_")
      puts "Processing #{original_filename} (#{filename})..."
      obj = bucket[original_filename]
      unless obj.present?
        obj = AWS::S3::S3Object.find(original_filename, 'cpkissmetrics')
        unless obj.present?
          puts "Object is nill. Skipping."
          next
        end
      end
      File.open("km_dump/#{filename}", 'w') { |f| f.write(obj.value) }
    end

    last_json_file = index_file.last.split(",").first.split("/").last
    unless File.exists? "km_dump/#{last_json_file}"
      raise "Kissmetrics dump download was corrupted, since #{last_json_file} was not downloaded. Aborting."
    end

    puts "Done"
  end
end
