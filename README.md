Fantasy Football Nerd API Ruby Gem
==================================

A Ruby Gem for the [Fantasy Football Nerd API](http://www.fantasyfootballnerd.com/fantasy-football-api) which: 

> takes the "wisdom of the crowd" to a new level by aggregating the fantasy football rankings of the best fantasy football sites on the planet to analyze the rankings given to each player to produce a consensus ranking.

This gem currently supports all Level 1 and Level 2 streams which cost $9 per season -- a total no-brainer if you're into fantasy sports and programming. Give the man his money.  

Here's what you get with $9 and this gem: 

* Current Week
* Team List
* Season schedule
* Player list
* Bye weeks
* Injuries
* Auction draft values
* Draft rankings - projected fantasy points for the entire season
* Draft projections - projected stats for each scoring category for the entire season 
* Weekly rankings - projected fantasy points (PPR || Standard)
* Weekly projections - projected stats for each scoring category

v1.0
----------------

Fantasy Football Nerd recently overhauled to their API which a) drastically improved their service and b) completely deprecated the old API. The previous version of this gem won't work anymore so update your Gemfiles. 

Cache your data!
----------------
Take heed to the warning on the [Fantasy Football Nerd API page](http://www.fantasyfootballnerd.com):

>The data does not generally change more than once or twice per day, so it becomes unnecessary to continually make the same calls. Please store the results locally and reference the cached responses... Your account may be suspended or API access revoked if you are found to be making excessive data calls.

Seriously, Fantasy Football Nerd is not a big operation. Don't abuse their servers.

Setup
=================
First, [sign up](http://www.fantasyfootballnerd.com/create-account) for a Fantasy Football Nerd account. Then... 

In plain ol' Ruby, install the gem:

```
gem install fantasy_football_nerd
```

And require it:

````ruby
require 'rubygems'
require 'fantasy_football_nerd'
````

If you're using Rails, add the gem to your Gemfile and run ```bundle install```

````ruby
gem 'fantasy_football_nerd'
````

Before you can access the feeds you must set your API key (found on the [Fantasy Football Nerd API dashboard](http://www.fantasyfootballnerd.com/api)) by one of two methods: 

Set an environment variable via the terminal (good for production environments where you don't want to commit credentials to a repo). 

````term
export FFNERD_API_KEY="ABC123DEF"
````

Set a class variable from your script (good for one-offs like pulling down stats from IRB).

```ruby
FFNerd.api_key = "ABC123DEF"
```

API Resources
===================

This gem supports all of Fantasy Football Nerd's Level 1 and Level 2 resources. Results are typically returned as an array of [ostructs](http://www.ruby-doc.org/stdlib-2.0/libdoc/ostruct/rdoc/OpenStruct.html) (which is basically a hash that you can access with "dot notation" as if it were an object instance variable). Fantasy Football Nerd returns keys in CamelCase but that's not very Ruby like. I've added snake_case attributes so that you can do ```player.displayName``` or ```player.display_name```, whichever suits your fancy. 

Teams
--------------------------
Returns an array of teams. 

```ruby
team = FFNerd.teams.first
team.code        # "ARI"
team.full_name   # "Arizona Cardinals"
team.short_name  # "Arizona"
```

Schedule
--------------------------
Returns an array of games. 

```ruby
game = FFNerd.schedule.first
game.game_id         # "1"
game.game_week       # "1"
game.game_date       # "2013-09-05"
game.away_team       # "BAL"
game.home_team       # "DEN"
```

Players
--------------------------
Returns an array of players. 

```ruby
player = FFNerd.players.first
player.player_id     # "2"
player.active        # "1"
player.jersey        # "3"
player.lname         # "Anderson"
player.fname         # "Derek"
player.display_name  # "Derek Anderson"
player.team          # "CAR"
player.position      # "QB"
player.height        # "6-6"
player.weight        # "240"
player.dob           # "1983-06-15"
player.college       # "Oregon State"
```

Bye Weeks
--------------------------
Returns an array of the teams on bye for the given week. 

```ruby
bye = FFNerd.byes(4).first
bye.team         # "CAR"
bye.bye_week     # "4"
bye.display_name # "Carolina Panthers"
```

Injuries
--------------------------
Returns an array of injured players. Takes an optional parameter for the week number, or defaults to the current week. 

```ruby
injury = FFNerd.injuries(6)     # all injuries for week 6
injury = FFNerd.injuries.first  # the first injury of the current week
injury.week               # "1"
injury.player_id          # "0"
injury.player_name        # "Javier Arenas"
injury.team               # "ARI"
injury.position           # "CB"
injury.injury             # "Hip"
injury.practice_status    # "Full Practice"
injury.game_status        # "Probable"
injury.notes              # ""
injury.last_update        # "2013-09-09"
injury.practice_status_id # 0
```


Auction Values
--------------------------
Returns an array of draft auction values. 

```ruby
value = FFNerd.auction_values.first
value.player_id     # "259"
value.min_price     # "60"
value.max_price     # "66"
value.avg_price     # "63"
value.display_name  # "Adrian Peterson"
value.team          # "MIN"
value.position      # "RB"
```

Current Week
--------------------------
Returns the current NFL week as an integer. 

```ruby
FFNerd.current_week  # 17
```

Standard Draft Rankings
--------------------------
Returns an array of players according to their projected draft values based on standard scoring. In this example I'm looking at the fourth element in the array because the PPR and standard rankings don't deviate until then in the test data. 

```ruby   
player = FFNerd.standard_draft_rankings[3]
player.playerId      # "1136"
player.position      # "RB"
player.displayName   # "C.J. Spiller"
player.fname         # "C.J."
player.lname         # "Spiller"
player.team          # "BUF"
player.byeWeek       # "12"
player.nerdRank      # "6.140"
player.positionRank  # "4"
player.overallRank   # "4"
```

PPR Draft Rankings
--------------------------
Returns an array of players according to their projected draft values based on PPR scoring. 

```ruby
player = FFNerd.ppr_draft_rankings[3]
player.player_id     # "454"
player.position      # "WR"
player.display_name  # "Calvin Johnson"
player.fname         # "Calvin"
player.lname         # "Johnson"
player.team          # "DET"
player.bye_week      # "9"
player.nerd_rank     # "7.209"
player.position_rank # "1"
player.overall_rank  # "4"
```

Draft Projections
--------------------------
Returns an array of players with projected stats for a number of scoring categories. This data is useless once the season starts. 

Must pass in a valid position of QB, RB, WR, TE, K, DEF.

```ruby
player = FFNerd.draft_projections('QB').first
player.player_id         # "14"
player.completions       # "422"
player.attempts          # "640"
player.passing_yards     # "4992"
player.passing_td        # "40"
player.passing_int       # "17"
player.rush_yards        # "28"
player.rush_td           # "1"
player.fantasy_points    # "335"
player.display_name      # "Drew Brees"
player.team              # "NO"
```

Weekly Rankings
--------------------------
Returns an array of players with expected weekly fantasy points for both standard and PPR scoring. 

Must request a specific position: QB, RB, WR, TE, K, DEF. You can also send along the specific week number (1-17). If you omit a week, it defaults to the current week. 

```ruby
player = FFNerd.weekly_rankings('QB', 2).first
player.week             # "2"
player.player_id        # "14"
player.name             # "Drew Brees"
player.position         # "QB"
player.team             # "NO"
player.standard         # "24.80"
player.standard_low     # "18.92"
player.standard_high    # "32.00"
player.ppr              # "24.80"
player.ppr_low          # "18.92"
player.ppr_high         # "32.00"
player.injury           # nil
player.practice_status  # nil
player.game_status      # nil
player.last_update      # nil
```

Weekly Projections
--------------------------
Returns an array of players with expected weekly values for each scoring category. 

Must request a specific position: QB, RB, WR, TE, K (But *NOT DEF!*). You can also send along the specific week number (1-17). If you omit a week, it defaults to the current week. 

```ruby
player = FFNerd.weekly_projections('QB', 1).first
player.week             # "1"
player.player_id        # "14"
player.position         # "QB"
player.pass_att         # "39.0"
player.pass_cmp         # "25.0"
player.pass_yds         # "317.0"
player.pass_td          # "2.0"
player.pass_int         # "1.0"
player.rush_att         # "1.0"
player.rush_yds         # "1.0"
player.rush_td          # "0.0"
player.fumbles_lost     # "0.0"
player.receptions       # "0.0"
player.rec_yds          # "0.0"
player.rec_td           # "0.0"
player.fg               # "0.0"
player.fg_att           # "0.0"
player.xp               # "0.0"
player.def_int          # "0.0"
player.def_fr           # "0.0"
player.def_ff           # "0.0"
player.def_sack         # "0.0"
player.def_td           # "0.0"
player.def_ret_td       # "0.0"
player.def_safety       # "0.0"
player.def_pa           # "0.0"
player.def_yds_allowed  # "0.0"
player.display_name     # "Drew Brees"
player.team             # "NO"
```

Player Information
-------------

*Commercial Access only!* 

Get biographical info for each player. You will need to pass along the playerId of the player you want. Unlike the FFNerd API, this resource does not return the player stats -- that comes from FFNerd.player_stats

```ruby
  player = FFNerd.player_info(13)
  player.player_id  # "13"
  player.star  # "1"
  player.active  # "1"
  player.jersey  # "12"
  player.lname  # "Brady"
  player.fname  # "Tom"
  player.display_name  # "Tom Brady"
  player.team  # "NE"
  player.position  # "QB"
  player.height  # "6-4"
  player.weight  # "225"
  player.dob  # "1977-08-03"
  player.college  # "Michigan"
  player.twitter_id  # "tomedbrady12"
```

Player Stats
-------------

*Commercial access only!* 

I deviated from the FFNerd API feed and broke historical stats off of the player information resource. I've also changed some of the field names to make them consistent with ```FFNerd.weekly_projections```.  

```ruby
year = 2000
week = 1
player_stats = FFNerd.player_stats(13)
stats = player_stats[year][week]
stats.year  # 2000
stats.player_id  # 13
stats.week  # 1
stats.game_date  # "09/03"
stats.opponent  # "TB"
stats.final_score  # "L16-21"
stats.game_played  # 0
stats.game_started  # 0
stats.completions  # 0
stats.pass_att  # 0
stats.percentage  # 0.00
stats.pass_yds  # 0
stats.avg_pass_yds  # 0.00
stats.pass_td  # 0
stats.interceptions  # 0
stats.sacks  # 0
stats.sack_yds  # 0
stats.qb_rating  # 0.00
stats.rush_att  # 0
stats.rush_yds  # 0
stats.rush_avg  # 0.00
stats.rush_td  # 0
stats.fumbles  # 0
stats.fumbles_lost  # 0
```

A player's ostruct/hash does not include keys for stats that would be irrelevant for him. For example, when you pull Matt Forte's stats, you'll find some values that are absent for Brady (and vice versa).

```ruby
year = 2008
week = 1
player_stats = FFNerd.player_stats(175)
stats = player_stats[year][week]
stats.receptions # 3
stats.rec_yds # 18
stats.rec_avg # 6.00
stats.long_rec # 9
stats.rec_td # 0
```

Daily Fantasy Projections
-------------

*Commercial access only!* 

Get Daily Fantasy Sports information from the three major DFS sites (fanduel, draftkings, and yahoo) for the upcoming week.
All projections are based on the respective DFS site's scoring rules.

There are three projections available:
1) Conservative - This is the minimum projection of the sampled aggregate sites.
2) Consensus - This is the 'NerdRank' average of the sampled aggregate sites. See more here: http://www.fantasyfootballnerd.com/nerdRank
3) Aggressive - This is the maximum projection of the sampled aggregate sites.

The bang for your buck is a metric combining salary and projection. Lower is better value.

```ruby
platform = "fanduel"
player = FFNerd.daily_fantasy_projections(platform).first
projection_type = "consensus" #Types: conservative, consensus, aggressive
consensus_projections = player.projections[projection_type]
player.player_id # 35
player.position # "QB"
player.name # "Joe Flacco"
player.team # "BAL"
player.salary # "8000"
consensus_projections["projected_points"] # 16.5
consensus_projections["bang_for_your_buck_score"] # 29.385
```

Daily Fantasy League Info
-------------

*Commercial access only!* 

Get information on league info for a given daily fantasy platform .
Projections are only available for the upcoming week, indicated by the current_week variable.

```ruby
platform = "fanduel"
info = FFNerd.daily_fantasy_league_info(platform)
info.current_week # "4"
info.platform # "FanDuel"
info.cap # 60000
info.roster_requirements # {"QB" => 1, "RB" => 2, "WR" => 3, "TE" => 1, "DEF" => 1, "K" => 1, "FLEX" => 0})
info.flex_positions # []
info.dev_notes # "Projections below are based...
```


Tests
===================

Set your API key to "test" to access FFNerd's test feeds. This is useful if you're developing your app prior to the beginning of the season or if you'd like to have a static dataset that won't change as the season progresses. All of the Rspec tests here use the test feeds. Speaking of RSpec... 

This gem includes comprehensive tests and uses VCR to cache http responses. If you're going to contribute, please write some tests. 

Contributors
======================
Greg Baugues ([greg@baugues.com](mailto:greg@baugues.com))<br/>
[www.baugues.com](http://www.baugues.com)<br/>
Dan Dimond ([dtdimond@gmail.com](mailto:dtdimond@gmail.com))


