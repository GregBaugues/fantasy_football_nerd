require 'rubygems'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr/cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data('APIKEY') { FFNerd.api_key }
end

