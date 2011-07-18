require 'bundler/setup'
require 'beetle'
require 'json'

client = Beetle::Client.new
client.register_message(:search)

["Joe Van Dyk", "Tenderlove", "Beetle", "EventMachine"].each do |query|
  status, result = client.rpc(:search, query)
  puts JSON.parse(result)
end
