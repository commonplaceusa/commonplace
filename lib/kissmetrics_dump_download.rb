class KissmetricsDumpDownload
  @queue = :statistics

  REDIS_LAST_PROCESSED_FILE = "kissmetrics:processing:last_processed_file"

  def self.perform
    require 'progressbar'
    require 'net/http'
    require 'rexml/document'

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

    last_processed_file = Resque.redis.get(REDIS_LAST_PROCESSED_FILE)
    if last_processed_file.nil?
      last_processed_file = "1.json"
      Resque.redis.set(REDIS_LAST_PROCESSED_FILE, last_processed_file)
    end

    index_file = File.read('km_dump/index.csv').split("\n")
    index_file.shift(1)
    index_file = index_file.sort { |l|
      l.split(",").first.split("/").last.split(".").first.to_i
    }.reverse
    while index_file.first.split(",").first.split("/").last != last_processed_file
      # puts "Already processed #{index_file.first.split(",").first.split("/").last}. Skipping"
      index_file.shift(1)
    end
    progress = ProgressBar.new("Download", index_file.count)

    index_file.each do |index_file_line|
      original_filename = index_file_line.split(",").first
      filename = original_filename.gsub("/", "_")
      # puts "Processing #{original_filename} (#{filename})..."
      obj = bucket[original_filename]
      unless obj.present?
        begin
          obj = AWS::S3::S3Object.find(original_filename, 'cpkissmetrics')
          unless obj.present?
            # puts "Object is nill. Skipping."
            next
          end
        rescue
          puts "Cycling #{index_file}"
          index_file << index_file_line
          next
        end
      end
      if File.exists? "km_dump/#{filename}"
        `rm -rf km_dump/#{filename}`
      end
      File.open("km_dump/#{filename}", 'w') { |f| f.write(obj.value) }
      progress.inc
    end

    progress.finish

    file_nums = index_file.map { |l| l.split(",").first.split("/").last.split(".").first.to_i }
    progress = ProgressBar.new("Verification", file_nums.count)
    max_file_num = file_nums.max
    min_file_num = file_nums.min
    (min_file_num..max_file_num).each do |file_num|
      unless File.exists? "km_dump/revisions_#{file_num.to_s}.json"
        puts "Kissmetrics dump download was corrupted, since #{file_num} was not downloaded. Aborting."
        exit 1
      end
      progress.inc
    end
    progress.finish

    Resque.redis.set(REDIS_LAST_PROCESSED_FILE, "#{max_file_num}.json")
  end
end
