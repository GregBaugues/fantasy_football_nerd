require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem', vcr: true do

  it 'should retrieve teams' do
    expect(FFNerd.teams.first).to be
  end

  it 'should retrieve the schedule' do
    expect(FFNerd.schedule.first).to be
  end

  it 'should retrieve players' do
    expect(FFNerd.players.first).to be
  end

  it 'should retrieve auction values' do
    expect(FFNerd.auction_values.first).to be
  end

end