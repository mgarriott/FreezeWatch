#!/usr/bin/ruby

require 'net/http'
require 'cgi'
require 'rexml/document'

class Weather
  @@url = 'http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php'

  def Weather.get_query_string(params)
    params.map{|k,v| "#{CGI::escape(k)}=#{CGI::escape(v)}"}.join('&')
  end

  def Weather.get_response(params)
    full_url = "#@@url?#{Weather.get_query_string(params)}"
    Net::HTTP.get_response(URI.parse(full_url))
  end

  def Weather.get_latlons(zipcodes)
    res = Weather.get_response({ 'listZipCodeList' => Weather.parse_zipcodes(zipcodes) })
    doc = REXML::Document.new(res.body)
    latlons = doc.elements['*/latLonList'].text.split
    latlons.map { |ll| LatLon.new(*ll.split(',')) }
  end

  def Weather.parse_zipcodes(zipcodes)
    zipcodes.class == Array ? zipcodes.join(' ') : zipcodes
  end
end

class LatLon
  
  attr_reader :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def to_s
    "Latitude: #@lat\nLongitude: #@lon"
  end

  def == other
    @lat == other.lat && @lon == other.lon
  end
end

#w = Weather.new
#puts w.get_latlons(['82801', '90210'])
