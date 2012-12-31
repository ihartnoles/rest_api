require './lib/api.rb'
require 'nokogiri'
 
# CRUD example with an api
 
def list_positions(api_object)
  puts "Current Positions:"
  doc = Nokogiri::XML.parse api_object.read
  names = doc.xpath('positions/position/name').collect {|e| e.text }
  puts names.join(", ")
  #puts ""
end
 
api = Api.new
list_positions(api)
 
# Create
puts "Creating position..."
api.create "Bobby Flay Fry Guy", 1
list_positions(api)
 
# Read one and do nothing with it
api.read 1
 
# Read all and get valid IDs
doc = Nokogiri::XML.parse api.read
ids = doc.xpath('positions/position/id').collect {|e| e.text }
 
# Update last record
puts "Updating last record ..."
api.update ids.last, "Robert Flaid", 2001
list_positions(api)
 
# Delete
puts "deleting last record ..."
api.delete ids.last
list_positions(api)