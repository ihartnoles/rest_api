require 'net/http'
 
class Api
  attr_accessor :url
  attr_accessor :uri
 
  def initialize
    @url = "http://localhost:3000/positions"
    @uri = URI.parse @url
  end
 
  # Create an position using a predefined XML template as a REST request.
  def create(name="Default Name", bOpen="1")
    xml_req =
    "<?xml version='1.0' encoding='UTF-8'?>
    <position>
      <bOpen type='integer'>#{bOpen}</bOpen>
      <name>#{name}</name>
    </position>"
 
    request = Net::HTTP::Post.new(@url)
    request.add_field "Content-Type", "application/xml"
    request.body = xml_req
 
    http = Net::HTTP.new(@uri.host, @uri.port)
    response = http.request(request)
 
    response.body    
  end
 
  # Read can get all positions with no arguments or
  # get one position with one argument.  For example:
  # api = Api.new
  # api.read 2 => one position
  # api.read   => all positions
  def read(id=nil)
    request = Net::HTTP.new(@uri.host, @uri.port)
 
    if id.nil?
      response = request.get("#{@uri.path}.xml")      
    else
      response = request.get("#{@uri.path}/#{id}.xml")    
    end
 
    response.body
  end
 
  # Update an position using a predefined XML template as a REST request.
  def update(id, name="Updated Name", bOpen=1)
    xml_req =
    "<?xml version='1.0' encoding='UTF-8'?>
    <position>
      <bOpen type='integer'>#{bOpen}</bOpen>
      <id type='integer'>#{id}</id>
      <name>#{name}</name>
    </position>"
 
    request = Net::HTTP::Put.new("#{@url}/#{id}.xml")
    request.add_field "Content-Type", "application/xml"
    request.body = xml_req
 
    http = Net::HTTP.new(@uri.host, @uri.port)
    response = http.request(request)
 
    # no response body will be returned
    case response
    when Net::HTTPSuccess
      return "#{response.code} OK"
    else
      return "#{response.code} ERROR"
    end
  end
 
  def delete(id)
    request = Net::HTTP::Delete.new("#{@url}/#{id}.xml")
    http = Net::HTTP.new(@uri.host, @uri.port)
    response = http.request(request)
 
    # no response body will be returned
    case response
    when Net::HTTPSuccess
      return "#{response.code} OK"
    else
      return "#{response.code} ERROR"
    end
  end
 
end