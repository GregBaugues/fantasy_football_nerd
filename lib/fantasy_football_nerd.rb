require 'json'
require 'ostruct'
require './lib/request.rb'
require './lib/util.rb'
require 'pry'

POSITIONS = %w{QB RB WR TE K DEF}

class FFNerd
  extend Request

  def self.api_key
    raise 'FFNERD_API_KEY environment variable not set' unless ENV['FFNERD_API_KEY']
    ENV['FFNERD_API_KEY']
  end

  def self.current_week
    response = request_service('schedule', api_key)
    response['currentWeek']
  end

  def self.ostruct_request(service_name, json_key, extras = [])
    data = request_service(service_name, api_key, extras)[json_key]
    data = data.values.flatten if data.is_a? Hash
    data.collect { |i| OpenStruct.new(i.add_snakecase_keys) }
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
    ostruct_request('injuries', 'Injuries')
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

  def self.weekly_rankings(position, week = nil)
    raise "Must pass in a valid position" unless POSITIONS.include?(position)
    raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
    week ||= current_week
    extras = [position, week, 1]
    ostruct_request('weekly-rankings', 'Rankings', extras)
  end

  # def self.standard_weekly_projections(position, week = nil)
  #   #FFNerd defaults to current week if week is left blank
  #   raise "Weekly projections don't include DEF (but you can find those values in weekly rankings)" if position == "DEF"
  #   raise "Must pass in a valid position" unless POSITIONS.include?(position)
  #   raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
  #   extras = [position, week]
  #   ostruct_request('weekly-projections', 'Projections', extras)
  # end

  # def self.ppr_weekly_projections(position, week = nil)
  #   raise "Weekly projections don't include DEF (but you can find those values in weekly rankings)" if position == "DEF"
  #   raise "Must pass in a valid position" unless POSITIONS.include?(position)
  #   raise "Your (optional) week must be between 1 and 17" if week && !(1..17).include?(week)
  #   week ||= current_week
  #   extras = [position, week, 1] # The 1 gives us back PPR data
  #   ostruct_request('weekly-projections', 'Projections', extras)
  # end

end
