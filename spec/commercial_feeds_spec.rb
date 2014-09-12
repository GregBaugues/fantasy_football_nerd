require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Commercial Feeds', vcr: true do

  before :each do
    FFNerd.api_key = 'test'
    #FFNerd.api_key = ENV['FFNERD_API_KEY']
    #puts FFNerd.api_key
  end

  it 'should retrieve a player' do
    player = FFNerd.player(13)
    expect(player.player_id).to eq "13"
    expect(player.star).to eq "1"
    expect(player.active).to eq "1"
    expect(player.jersey).to eq "12"
    expect(player.lname).to eq "Brady"
    expect(player.fname).to eq "Tom"
    expect(player.display_name).to eq "Tom Brady"
    expect(player.team).to eq "NE"
    expect(player.position).to eq "QB"
    expect(player.height).to eq "6-4"
    expect(player.weight).to eq "225"
    expect(player.dob).to eq "1977-08-03"
    expect(player.college).to eq "Michigan"
    expect(player.twitter_id).to eq "tomedbrady12"
  end

end