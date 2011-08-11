require 'net/https'

http = Net::HTTP.new('www.google.com', 443)
http.use_ssl = true
path = '/accounts/ClientLogin'

data = 'accountType=HOSTED_OR_GOOGLE&Email=jason@commonplaceusa.com&Passwd=601845jrB&service=wise'

headers = {
  'Content-Type' => 'application/x-www-form-urlencoded'
}

resp, data = http.post(path, data, headers)

auth_string = data[/Auth=(.*)/, 1]
headers['Authorization'] = "GoogleLogin auth=#{auth_string}"
