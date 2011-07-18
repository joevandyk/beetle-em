require "bundler/setup"
require 'beetle'
require 'nokogiri'
require 'json'
require 'em-http-request'

client = Beetle::Client.new
client.register_queue(:search)

client.register_handler(:search) do |m|
  query = m.data

  uri = "http://www.google.com/search?q=#{URI.encode(query)}"
  http = EM::HttpRequest.new(uri).get
  http.callback do |page|
    doc = Nokogiri::HTML(page.response)
    result = doc.css('h3.r a.l').map { |link| link.content }.to_json
    # I want to return result
    # Maybe something like
    # m.finished!(result)
  end
end

client.listen do
  puts "started google search server"
end
