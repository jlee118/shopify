require 'rubygems'
require 'sinatra'
require 'base64'
require 'openssl'
require 'httparty'
require 'json'

SHARED_SECRET = 'a2e5e6d5a356c6aa2f3db29046cd63cdd71ac02f8d0ff30fdbf567db575cbdde'
API_KEY = '3807ea8d65c3831a591d35dbf1d2bb59'
PASSWORD = '068699831be90deba1024bfc1242ab49'
STORE_NAME = 'test-store-1737.myshopify.com'

helpers do
  # Compare the computed HMAC digest based on the shared secret and the request contents
  # to the reported HMAC in the headers

  def verify_webhook(data, hmac_header)
    digest  = OpenSSL::Digest::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHARED_SECRET, data)).strip
    calculated_hmac == hmac_header
  end
end

# Respond to HTTP POST requests sent to this web service
post '/' do
  request.body.rewind
  data = request.body.read
  verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])

  # Output 'true' or 'false'
  puts "Webhook verified: #{verified}"
end

get '/order' do
	request.body.rewind
	data = JSON.parse request.body.read
	item_count = data['line_items'].count
	item_ids = Array.new(item_count)
	item_price = Array.new(item_count)
	for i in 0..(item_count - 1)
		id = data['line_item'][i]['id']
		url = "https://#{API_KEY}:#{PASSWORD}@#{STORE_NAME}/admin/products.json"
		response = HTTParty.get(url).parsed.response	
		price = 
		item_ids[i] = data['line_item'][i]['id']
		item_price[i] = data['line_item'][i]['id']
	

end