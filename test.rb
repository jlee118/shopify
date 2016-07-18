require 'rubygems'
require 'sinatra'
require 'openssl'
require 'httparty'

API_KEY = '3807ea8d65c3831a591d35dbf1d2bb59'
PASSWORD = '068699831be90deba1024bfc1242ab49'
STORE_NAME = 'test-store-1737.myshopify.com'

post '/order' do
	redirect to('http://google.ca')
end