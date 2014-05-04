require 'spec_helper'

describe Weather do
  it "can get query string" do
    query_params = {
      'listZipCodeList=82801' => { 'listZipCodeList' => '82801' },
      'listZipCodeList=82801+90210' => { 'listZipCodeList' => '82801 90210' }
    }

    query_params.each { |k,v|
      expect(Weather.get_query_string(v)).to eq(k)
    }
  end

  it "can get lat long" do
    pairs = {
      '20910' => LatLon.new('39.0138', '-77.0242'),
      '25414' => LatLon.new('39.2851', '-77.8575'),
      '82801' => LatLon.new('44.7921', '-106.957'),
      '90210' => LatLon.new('34.0995', '-118.414')
    }

    pairs.each do |k,v|
      Weather.get_latlons(k).each { |ll| expect(ll).to eq(v) }
    end

    Weather.get_latlons(pairs.keys).each_with_index do |ll, i|
      expect(ll).to eq(pairs.values[i])
    end
  end

  it "can get min temp" do
    min_temp = Weather.get_min_temp('82801').to_i
    expect(min_temp < 85).to be_true
    expect(min_temp > -30).to be_true
  end

  it "retries request when SocketError is thrown" do
    first_run = true
    Net::HTTP.stub(:get_response) do
      if first_run
        first_run = false
        raise SocketError
      end
    end

    expect(Weather).to receive(:sleep).and_return(5)

    expect(Net::HTTP).to receive(:get_response).at_least(1).times
    Weather.get_response({ 'fake' => 'params' })
  end

end
