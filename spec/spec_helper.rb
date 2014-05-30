require 'rubygems'
require 'vcr'

RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr/cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data('APIKEY') { FFNerd.api_key }
end

