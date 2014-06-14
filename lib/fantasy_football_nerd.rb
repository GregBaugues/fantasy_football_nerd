require 'json'
require 'ostruct'
require './lib/requests.rb'

class FFNerd
  extend Requests

  def self.api_key
    raise 'API key not set' unless ENV['FFNERD_API_KEY']
    ENV['FFNERD_API_KEY']
  end

  def self.teams
    response = request_service('nfl-teams', api_key)
    response['NFLTeams'].collect { |t| OpenStruct.new(t) }
  end

  def self.schedule
    response = request_service('schedule', api_key)
    response['Schedule'].collect { |g| OpenStruct.new(g) }
  end

end