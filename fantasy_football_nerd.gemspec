Gem::Specification.new do |s|
  s.name = "fantasy_football_nerd"
  s.version = "1.1.1"
  s.authors = ["Greg Baugues"]
  s.date = %q{2015-10-20}
  s.description = 'Fantasy Football Nerd API wrapper'
  s.summary = 'A ruby gem for the Fantasy Football Nerd API'
  s.email = 'greg@baugues.com'
  s.files = ['README.md',
    'lib/fantasy_football_nerd.rb',
    'lib/fantasy_football_nerd/util.rb',
    'lib/fantasy_football_nerd/request.rb',
    'lib/fantasy_football_nerd/commercial_feeds.rb',
    'spec/fantasy_football_nerd_spec.rb',
    'spec/request_spec.rb',
    'spec/api_key_setter_spec.rb',
    'spec/spec_helper.rb',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_auction_values.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_bye_weeks.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_draft_projections.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_fanduel_s_league_info.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_Flacco_s_dfs_fanduel_projections.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_injuries_with_a_week.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_injuries_without_a_week.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_players.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_teams.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_the_current_week.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_the_ppr_draft_rankings.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_the_schedule.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_the_standard_draft_rankings.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_weekly_projections.yml',
    'spec/vcr/cassettes/Fantasy_Football_Nerd_Gem/should_retrieve_weekly_rankings.yml']
  s.homepage = 'http://www.baugues.com'
  s.has_rdoc = false
  s.rubyforge_project = 'fantasy_football_nerd'
end
