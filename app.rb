require 'sinatra'
require 'openssl'
require 'httparty'
require 'json'
#require 'base64'
require 'shopify_api'

SHARED_SECRET = 'a2e5e6d5a356c6aa2f3db29046cd63cdd71ac02f8d0ff30fdbf567db575cbdde'
API_KEY = '3807ea8d65c3831a591d35dbf1d2bb59'
PASSWORD = '068699831be90deba1024bfc1242ab49'
STORE_NAME = 'test-store-1737.myshopify.com'
URL = "https://#{API_KEY}:#{PASSWORD}@#{STORE_NAME}/admin"
ShopifyAPI::Base.site = URL
BID_MARGIN = 0.2
BID_DECREMENT = 0.004

# helpers do
#   def verify_webhook(data, hmac_header)
#     digest  = OpenSSL::Digest.new('sha256')
#     calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHARED_SECRET, data)).strip
#     calculated_hmac == hmac_header
#   end
# end

post '/order' do
	request.body.rewind
	data = JSON.parse request.body.read
	#puts JSON.pretty_generate(data)
	#verified = verify_webhook(data, env["HTTP_X_SHOPIFY_HMAC_SHA256"])
	item_count = data['line_items'].count
	for i in 0..(item_count - 1)
		id = data['line_items'][i]['product_id']
		product = ShopifyAPI::Product.find(id)
		variantNumber = product.variants.count
		for j in 0..(variantNumber - 1)
			originalPrice = product.variants[j].compare_at_price.to_f
			currentPrice = product.variants[j].price.to_f
			if currentPrice > originalPrice * (1 - BID_MARGIN)
				product.variants[j].price = (currentPrice - originalPrice * BID_DECREMENT).round(2)
				puts "new price is #{product.variants[j].price}"
				product.save
			else
				puts "currently selling at floor price, no more discount!"
			end
		end
	end
end