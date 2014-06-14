require 'json'
require './lib/requests.rb'

class FFNerd
  extend Requests

  def self.api_key
    raise 'API key not set' unless ENV['FFNERD_API_KEY']
    ENV['FFNERD_API_KEY']
  end

  def self.teams
    data = request_service('nfl-teams', api_key)
  end

end