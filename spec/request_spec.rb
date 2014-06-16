require 'spec_helper.rb'
require './lib/request.rb'
include Request

describe 'Request' do
  it 'should create a service url without extras' do
    url = service_url('draft-rankings', '12345')
    expect(url).to eq 'http://www.fantasyfootballnerd.com/service/draft-rankings/json/12345'
  end

  it 'should create a service url with extras' do
    url = service_url('draft-rankings', '12345', 1)
    expect(url).to eq 'http://www.fantasyfootballnerd.com/service/draft-rankings/json/12345/1'
  end
end