require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem' do

  it 'should set an api key' do
    FFNerd.api_key = "1234"
    expect(FFNerd.api_key).to eq "1234"
  end

end