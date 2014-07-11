require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'API KEY setter' do

  before :all do
    ENV['FFNERD_API_KEY'] = '12345'
  end

  it 'should set the API key from the ENV variable' do
    expect(FFNerd.api_key).to eq '12345'
  end

  it 'should set the API key from the setter' do
    FFNerd.api_key = '678910'
    expect(FFNerd.api_key).to eq '678910'
  end
end