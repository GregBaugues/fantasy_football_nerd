require 'spec_helper.rb'
require './lib/urls.rb'
include Urls

describe 'Urls' do

  it 'should return a url when passed a service' do
    expect(service_url('nfl-teams', '123')).to eq "http://www.fantasyfootballnerd.com/service/nfl-teams/json/123"
  end

  it 'should allow an xml format' do
    expect(service_url('nfl-teams', '123', :xml)).to eq "http://www.fantasyfootballnerd.com/service/nfl-teams/xml/123"
  end

end
