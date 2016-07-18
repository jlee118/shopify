require 'sinatra'
require 'openssl'
require 'httparty'
require 'json'
require 'base64'

SHARED_SECRET = 'a2e5e6d5a356c6aa2f3db29046cd63cdd71ac02f8d0ff30fdbf567db575cbdde'
API_KEY = '3807ea8d65c3831a591d35dbf1d2bb59'
PASSWORD = '068699831be90deba1024bfc1242ab49'
STORE_NAME = 'test-store-1737.myshopify.com'

helpers do
  def verify_webhook(data, hmac_header)
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHARED_SECRET, data)).strip
    calculated_hmac == hmac_header
  end
end

post '/order' do
	request.body.rewind
	data = JSON.parse request.body.read
	#verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])
	item_count = data['line_items'].count
	puts item_count
end