require './lib/urls.rb'
require 'open-uri'

module Requests
  include Urls

  def request_service(service, api_key)
    url = service_url(service, api_key)
    JSON.parse(open(url).read)
  end

end