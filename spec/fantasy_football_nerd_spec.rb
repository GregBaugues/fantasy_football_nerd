require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem', vcr: true do

  before :all do
    ENV['FFNERD_API_KEY'] = 'test'
  end

  it 'should retrieve teams' do
    team = FFNerd.teams.first
    expect(team.code).to eq "ARI"
    expect(team.fullName).to eq "Arizona Cardinals"
    expect(team.shortName).to eq "Arizona"
  end

  it 'should retrieve the schedule' do
    expect(FFNerd.schedule.first).to be
  end

  it 'should retrieve players' do
    expect(FFNerd.players.first).to be
  end

  it 'should retrieve bye weeks' do
    expect(FFNerd.byes(4)).to be
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