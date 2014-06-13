module Urls

  def base_url
    "http://www.fantasyfootballnerd.com/service"
  end

  def service_url(service, api_key)
    service = service.to_s
    [base_url, service, "json", api_key].join("/")
  end

  def test_service_url(service, format = :json)
    url = base_url(service, 'XXX', format) + "/#{test}"
    url.gsub!('/XXX', '')
  end

  module_function :base_url, :service_url, :test_service_url

end

