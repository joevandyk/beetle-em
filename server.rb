require "bundler/setup"
require 'beetle'
require 'nokogiri'
require 'open-uri'
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
    result = doc.css('h3.r a.l').map do |link|
      link.content
    end
    # I want to return result.to_json
    # Maybe something like
    # m.finished!(result.to_json)
  end
end

client.listen do
  puts "started google search server"
end
