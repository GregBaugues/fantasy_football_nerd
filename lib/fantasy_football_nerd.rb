require 'json'
require './lib/requests.rb'

class FFNerd
  @@api_key

  def self.api_key=(value)
    @@api_key = value
  end

end