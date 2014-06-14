require 'open-uri'

module Request

  def base_url
    "http://www.fantasyfootballnerd.com/service"
  end

  def service_url(service, api_key, extras = [])
    service = service.to_s
    [base_url, service, "json", api_key, extras].join("/")
  end

  def test_service_url(service, format = :json)
    url = base_url(service, 'XXX', format) + "/#{test}"
    url.gsub!('/XXX', '')
  end

  def request_service(service, api_key, extras = [])
    url = service_url(service, api_key, extras)
    JSON.parse(open(url).read)
  end

end