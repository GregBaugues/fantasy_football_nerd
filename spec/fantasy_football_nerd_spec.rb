require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem', vcr: true do

  it 'should retrieve teams' do
    expect(FFNerd.teams.first).to be
  end

end