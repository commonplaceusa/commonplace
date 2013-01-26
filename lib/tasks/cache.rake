
namespace :cache do
  desc 'Clear cache'
  task :clear => :environment do
    Rails.cache.clear
  end

  desc 'Clear Cloudflare cache'
  task :clear_cdn => :environment do
    parameters = {
      a: "fpurge_ts",
      tkn: "3009bf48662eff1fdfb61c13fda0ac8ee2b47",
      email: "jason@commonplace.in",
      z: "ourcommonplace.com",
      v: "1"
    }
    response = RestClient.post 'https://www.cloudflare.com/api_json.html', parameters
    puts response
  end
end
