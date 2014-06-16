require 'json'
require 'ostruct'
require './lib/request.rb'
require './lib/util.rb'

POSITIONS = %w{QB RB WR TE K DEF}

class FFNerd
  extend Request

  def self.api_key
    raise 'API key not set' unless ENV['FFNERD_API_KEY']
    ENV['FFNERD_API_KEY']
  end

  def self.ostruct_request(service_name, json_key)
    response = request_service(service_name, api_key)
    response[json_key].each { |hash| hash.add_snakecase_keys }
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

  def self.current_week
    response = request_service('schedule', api_key)
    response['currentWeek']
  end

  def self.standard_draft_rankings
    response = request_service('draft-rankings', api_key)
    ostruct_request('draft-rankings', 'DraftRankings')
  end

  def self.ppr_draft_rankings
    #requires a 1 appended to url for ppr rankings
    response = request_service('draft-rankings', api_key, '1')
    ostruct_request('draft-rankings', 'DraftRankings')
  end

  def self.weekly_projections(position, week = nil)
    #FFNerd will default to current week if week is left blank
    raise "Weekly projections does not include DEF (but you can find those values in weekly rankings)" if position == "DEF"
    raise "Must pass in a valid position" unless POSITIONS.include?(position)
    raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
    extras = [position, week]
    response = request_service('weekly-projections', api_key, extras)
    ostruct_request('weekly-projections', 'Projections')
  end

end
