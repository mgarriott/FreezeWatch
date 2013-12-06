#!/usr/bin/ruby

$:.unshift File.join(File.dirname(__FILE__), "..")

require 'test/unit'
require 'weather'

class WeatherTest < Test::Unit::TestCase

  def test_get_query_string
    query_params = {
      'listZipCodeList=82801' => { 'listZipCodeList' => '82801' },
      'listZipCodeList=82801+90210' => { 'listZipCodeList' => '82801 90210' }
    }

    query_params.each { |k,v|
      assert_equal(k, Weather.get_query_string(v))
    }
  end

  def test_get_latlons
    pairs = {
      '20910' => LatLon.new('39.0138', '-77.0242'),
      '25414' => LatLon.new('39.2851', '-77.8575'),
      '82801' => LatLon.new('44.7921', '-106.957'),
      '90210' => LatLon.new('34.0995', '-118.414')
    }

    pairs.each { |k,v|
      Weather.get_latlons(k).each { |ll|
        assert_equal(v, ll)
      }
    }

    Weather.get_latlons(pairs.keys).each_with_index { |ll, i|
      assert_equal(pairs.values[i], ll)
    }
  end

  def test_get_min_temp
    min_temp = Weather.get_min_temp('82801').to_i
    assert(min_temp < 85)
    assert(min_temp > -30)
  end

end
