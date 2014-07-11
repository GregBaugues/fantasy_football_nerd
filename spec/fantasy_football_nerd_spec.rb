require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem', vcr: true do

  before :all do
    ENV['FFNERD_API_KEY'] = 'test'
  end

  it 'should retrieve teams' do
    team = FFNerd.teams.first
    expect(team.code).to eq "ARI"
    expect(team.full_name).to eq "Arizona Cardinals"
    expect(team.short_name).to eq "Arizona"
  end

  it 'should retrieve the schedule' do
    game = FFNerd.schedule.first
    expect(game.game_id).to eq "1"
    expect(game.game_week).to eq "1"
    expect(game.game_date).to eq "2013-09-05"
    expect(game.away_team).to eq "BAL"
    expect(game.home_team).to eq "DEN"
  end

  it 'should retrieve players' do
    player = FFNerd.players.first
    expect(player.player_id).to eq "2"
    expect(player.active).to eq "1"
    expect(player.jersey).to eq "3"
    expect(player.lname).to eq "Anderson"
    expect(player.fname).to eq "Derek"
    expect(player.display_name).to eq "Derek Anderson"
    expect(player.team).to eq "CAR"
    expect(player.position).to eq "QB"
    expect(player.height).to eq "6-6"
    expect(player.weight).to eq "240"
    expect(player.dob).to eq "1983-06-15"
    expect(player.college).to eq "Oregon State"
  end

  it 'should retrieve bye weeks' do
    bye = FFNerd.byes(4).first
    expect(bye.team).to eq "CAR"
    expect(bye.bye_week).to eq "4"
    expect(bye.display_name).to eq "Carolina Panthers"
  end

  it 'should retrieve injuries without a week' do
    expect(FFNerd.injuries).to be
  end

  it 'should retrieve injuries with a week' do
    expect(FFNerd.injuries(1)).to be
  end

  it 'should retrieve auction values' do
    expect(FFNerd.auction_values.first).to be
  end

  it 'should retrieve the current week' do
    expect(FFNerd.current_week).to eq 17
  end

  it 'should retrieve the standard draft rankings' do
    expect(FFNerd.standard_draft_rankings).to be
  end

  it 'should retrieve the ppr draft rankings' do
    expect(FFNerd.ppr_draft_rankings).to be
  end

  it 'should retrieve weekly rankings' do
    expect(FFNerd.weekly_rankings('QB')).to be
  end

  # it 'should retrieve standard weekly projections' do
  #   expect(FFNerd.standard_weekly_projections('QB')).to be
  # end

  # it 'should retrieve ppr weekly projections' do
  #   expect(FFNerd.ppr_weekly_projections('QB')).to be
  # end

end