require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd/util.rb'

describe 'Utility helpers' do

  it 'should change the year and week keys to ints' do
    stats = {
      '2012' => {'1' => 'one', '2' => 'two'},
      '2013' => {'1' => 'three', '2' => 'four'}
    }
    stats.change_keys_to_ints
    expect(stats[2012][1]).to eq 'one'
    expect(stats[2012][2]).to eq 'two'
    expect(stats[2013][1]).to eq 'three'
    expect(stats[2013][2]).to eq 'four'
  end

  it 'should not change a key that\'s not a good integer' do
    stats = {'bob' => 'whatever'}
    stats.change_keys_to_ints
    expect(stats['bob']).to eq 'whatever'
  end

  it 'should change keys given a hash' do
    keys_hash = {'PlayerID' => 'player_id', 'RushTDS' => 'rush_td' }
    hash = {'PlayerID' => 167, 'RushTDS' => 10 }
    hash.change_keys(keys_hash)
    expect(hash['player_id']).to eq 167
    expect(hash['rush_td']).to eq 10
    expect(hash['PlayerID']).to be nil
  end

end