require "bundler/setup"
require 'beetle'
require 'nokogiri'
require 'open-uri'
require 'json'

client = Beetle::Client.new
client.register_queue(:search)

client.register_handler(:search) do |m|
  query = m.data

  result = []
  doc = Nokogiri::HTML(open("http://www.google.com/search?q=#{URI.encode(query)}").read)
  doc.css('h3.r a.l').each do |link|
    result << link.content
  end
  result.to_json
end

client.listen do
  puts "started google search server"
end
