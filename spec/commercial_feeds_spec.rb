require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Commercial Feeds', vcr: true do

  before :each do
    FFNerd.api_key = 'test'
  end

  it 'should retrieve player information' do
    player = FFNerd.player_info(13)
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

  it 'should retrieve Brady\'s player stats' do
    year = 2000
    week = 1
    player_stats = FFNerd.player_stats(13)
    stats = player_stats[year][week]
    expect(stats.year).to eq 2000
    expect(stats.player_id).to eq 13
    expect(stats.week).to eq 1
    expect(stats.game_date).to eq "09/03"
    expect(stats.opponent).to eq "TB"
    expect(stats.final_score).to eq "L16-21"
    expect(stats.game_played).to eq 0
    expect(stats.game_started).to eq 0
    expect(stats.completions).to eq 0
    expect(stats.pass_att).to eq 0
    expect(stats.percentage).to eq 0.00
    expect(stats.pass_yds).to eq 0
    expect(stats.avg_pass_yds).to eq 0.00
    expect(stats.pass_td).to eq 0
    expect(stats.interceptions).to eq 0
    expect(stats.sacks).to eq 0
    expect(stats.sack_yds).to eq 0
    expect(stats.qb_rating).to eq 0.00
    expect(stats.rush_att).to eq 0
    expect(stats.rush_yds).to eq 0
    expect(stats.rush_avg).to eq 0.00
    expect(stats.rush_td).to eq 0
    expect(stats.fumbles).to eq 0
    expect(stats.fumbles_lost).to eq 0
  end

  it 'should retrieve Forte\'s player stats' do
    year = 2008
    week = 1
    player_stats = FFNerd.player_stats(175)
    stats = player_stats[year][week]
    expect(stats.year).to eq 2008
    expect(stats.player_id).to eq 175
    expect(stats.week).to eq 1
    expect(stats.game_date).to eq "09/07"
    expect(stats.opponent).to eq "@IND"
    expect(stats.final_score).to eq "W29-13"
    expect(stats.game_played).to eq 1
    expect(stats.game_started).to eq 1
    expect(stats.rush_att).to eq 23
    expect(stats.rush_yds).to eq 123
    expect(stats.rush_avg).to eq 5.30
    expect(stats.rush_td).to eq 1
    expect(stats.long_run).to eq 50
    expect(stats.receptions).to eq 3
    expect(stats.rec_yds).to eq 18
    expect(stats.rec_avg).to eq 6.00
    expect(stats.long_rec).to eq 9
    expect(stats.rec_td).to eq 0
    expect(stats.fumbles).to eq 0
    expect(stats.fumbles_lost).to eq 0
  end
end