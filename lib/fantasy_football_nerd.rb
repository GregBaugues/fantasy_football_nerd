require 'json'
require 'ostruct'
require 'fantasy_football_nerd/request.rb'
require 'fantasy_football_nerd/util.rb'
require 'fantasy_football_nerd/commercial_feeds.rb'

POSITIONS = %w{QB RB WR TE K DEF}
DFS_PLATFORMS = %w{fanduel draftkings yahoo}

class FFNerd
  @@api_key = nil

  extend Request
  extend CommercialFeeds

  def self.api_key
    @@api_key ||= ENV['FFNERD_API_KEY']
    raise 'API key not set' if @@api_key.nil?
    @@api_key
  end

  def self.api_key=(key)
    @@api_key = key
  end

  def self.current_week
    player = request_service('schedule', api_key)
    player['currentWeek']
  end

  def self.ostruct_request(service_name, json_key, extras = [])
    extras = [extras].flatten
    data = request_service(service_name, api_key, extras)[json_key]
    data = data.values.flatten if data.is_a? Hash
    data.collect { |i| OpenStruct.new(i.add_snakecase_keys) }
  end

  def self.weather
    ostruct_request('weather', 'Games')
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

  def self.byes(week)
    raise "Must include a bye week between 4 and 12" unless (4..12).include?(week)
    ostruct_request('byes', "Bye Week #{week}")
  end

  def self.injuries(week = nil)
    extras = [week]
    ostruct_request('injuries', 'Injuries', extras)
  end

  def self.auction_values
    ostruct_request('auction', 'AuctionValues')
  end

  def self.standard_draft_rankings
    ostruct_request('draft-rankings', 'DraftRankings')
  end

  def self.ppr_draft_rankings
    #appended a 1 to url for ppr rankings
    ostruct_request('draft-rankings', 'DraftRankings', '1')
  end

  def self.draft_projections(position)
    raise "Must pass in a valid position" unless POSITIONS.include?(position)
    ostruct_request('draft-projections', 'DraftProjections', [position])
  end

  def self.weekly_rankings(position, week = nil)
    raise "Must pass in a valid position" unless POSITIONS.include?(position)
    raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
    week ||= current_week
    extras = [position, week, 1]
    ostruct_request('weekly-rankings', 'Rankings', extras)
  end

  def self.weekly_projections(position, week = nil)
    #FFNerd defaults to current week if week is left blank
    raise "Must pass in a valid position" unless POSITIONS.include?(position)
    raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
    week ||= current_week
    extras = [position, week]
    ostruct_request('weekly-projections', 'Projections', extras)
  end
end
