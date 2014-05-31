module Urls

  def base_url
    "http://www.fantasyfootballnerd.com/service"
  end

  def service_url(service, api_key, format = :json)
    format = format.to_sym
    raise "Only xml and json are valid formats" unless [:json, :xml].include?(format)
    [base_url, service, format.to_s, api_key].join("/")
  end

  def test_service_url(service, format = :json)
    url = base_url(service, 'XXX', format) + "/#{test}"
    url.gsub!('/XXX', '')
  end

  module_function :base_url, :service_url, :test_service_url

end

