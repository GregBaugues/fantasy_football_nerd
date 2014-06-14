require 'json'
require 'ostruct'
require './lib/request.rb'

class FFNerd
  extend Request

  def self.api_key
    raise 'API key not set' unless ENV['FFNERD_API_KEY']
    ENV['FFNERD_API_KEY']
  end

  def self.ostruct_request(service_name, json_key)
    response = request_service(service_name, api_key)
    response[json_key].collect { |i| OpenStruct.new(i) }
  end

  def self.teams
    ostruct_request('nfl-teams', 'NFLTeams')
  end

  def self.schedule
    ostruct_request('schedule', 'Schedule')
  end

  def self.players
    ostruct_request('players', 'Players')
  end

  def self.auction_values
    ostruct_request('auction', 'AuctionValues')
  end

  def self.ppr_draft_projections
    ostruct_request('draft-projections', 'DraftRankings')
  end

  def self.current_week
    response = request_service('schedule', api_key)
    response['currentWeek']
  end

end