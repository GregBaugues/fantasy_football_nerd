require 'spec_helper.rb'
require './lib/requests.rb'
include Requests

describe 'Requests' do

    it 'should return teams' do
    VCR.use_cassette 'nfl-teams' do
      data = request_service('nfl-teams', ENV['FFNERD_API_KEY'])
    end

  end

end