require 'test_helper'

class TestProtectedPlanetReader < ActiveSupport::TestCase

  def setup
    Rails.application.secrets.protected_planet_api_url = 'http://mywebsite.com/api/protected_areas/'
    @reader = ProtectedPlanetReader.new
  end

  test '#protected_area_from_wdpaid returns a hash with the given protected area from ProtectedPlanet API' do
    json_file = File.read(File.join('test', 'fixtures', 'pp_area.json'))

    stub_request(
      :get,'http://mywebsite.com/api/protected_areas/1'
    ).to_return(status: 200, body: json_file, headers: {})

    protected_area_hash = @reader.protected_area_from_wdpaid(id: 1)

    assert_equal 'Killbear', protected_area_hash[:name]
  end

  test '#protected_area_from_wdpaid raises a custom exception if the HTTP GET fails' do
    stub_request(
      :get,'http://mywebsite.com/api/protected_areas/1'
    ).to_return(status: 404)

    assert_raise ProtectedPlanetReader::ProtectedAreaRetrievalError do
      @reader.protected_area_from_wdpaid id: 1
    end
  end
end
