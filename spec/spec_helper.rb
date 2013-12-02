require 'rubygems'
require 'simplecov'
require 'vcr'
require 'timecop'

RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr/cassettes"
  c.hook_into :fakeweb
  c.filter_sensitive_data('APIKEY') { FFNerd.api_key }
end

def test_values(object, expected_values)
  expected_values.each do |attribute, value|
    object[attribute].should == value
  end
end

def with_stub_feeds
  player = test_player
  player.projection = Hashie::Mash.new
  player.projection.standard = 26
  FFNerd.stub(:projections).and_return([player])

  player = test_player
  player.injury = Hashie::Mash.new
  player.injury.injury_desc = "Sprained Ankle"
  FFNerd.stub(:injuries).and_return([player])
  yield
end

def test_player
  player = Hashie::Mash.new
  player.id = 12
  player.position = 'RB'
  player.team = 'SEA'
  player
end