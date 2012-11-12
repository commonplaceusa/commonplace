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

    AWS::S3::Bucket.find('cpkissmetrics').objects.each do |obj|
      filename = obj.key.gsub("/", "_")
      File.open("km_dump/#{filename}", 'w') { |f| f.write(obj.value) }
      puts "Processed #{filename}"
    end

    puts "Done"
  end
end
