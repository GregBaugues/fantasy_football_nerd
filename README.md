Fantasy Football Nerd API
==========================

A Ruby Gem for the [Fantasy Football Nerd API](http://www.fantasyfootballnerd.com/api).

[Fantasy Football Nerd](http://www.fantasyfootballnerd.com) "takes the 'wisdom of the crowd' to a new level by aggregating the fantasy football rankings of the best fantasy football sites... and weighting the rankings based upon past accuracy."

Fantasy Football Nerd provides an API with access to this fantasy football data:

* Team List
* Season schedule
* Player list
* Bye weeks
* Injuries
* Auction draft values
* Standard/PPR draft rankings
* Standard/PPR draft projections
* Weekly rankings
* Weekly projections
* Player Details (including recent articles)
* Weekly Projections
* Preseason Draft Rankings (not currently supported)
* Season Schedule (not currently supported)
* Current week

Full API access costs $9 for a season subsciption, though if you are a developer with a modicum of interest in Fantasy Football, this is the best $9 you will spend all season.

v1.0
----------------

Fantasy Football Nerd recently overhauled to their API that a) drastically improved their service and b) completed deprecated the old API. The previous version of this gem won't work anymore so update your Gemfiles. 

Cache your data!
----------------
Take heed to the warning on the [Fantasy Football Nerd API page](http://www.fantasyfootballnerd.com):

>The data does not generally change more than once or twice per day, so it becomes unnecessary to continually make the same calls. Please store the results locally and reference the cached responses... Your account may be suspended or API access revoked if you are found to be making excessive data calls.

Seriously, FFN is not a big operation. Don't abuse their servers.

Setup
=================
[Sign up](http://www.fantasyfootballnerd.com/create-account) up for a Fantasy Football Nerd account.

In Ruby, install the gem:

        gem install fantasy_football_nerd

And require it:

````ruby
require 'rubygems'
require 'fantasy_football_nerd'
````

In Rails, add the gem to your gemfile and run <tt>bundle install</tt>

````ruby
gem 'fantasy_football_nerd'
````

Set your api_key as an environment variable before before making a call. You can find it on the [FFN api page](http://www.fantasyfootballnerd.com/api).

````term
export FFNERD_API_KEY = 123456789
````

API Resources
===================

This gem supports all Level 1 and Level 2 feeds listed above. Results are returned in an [ostruct](http://www.ruby-doc.org/stdlib-2.0/libdoc/ostruct/rdoc/OpenStruct.html) -- think of it as a hash that you can access as if it were an instance of a custom Class. 

Fantasy Football Nerd returns keys in CamelCase but that's not very ruby like. I've added snake_case attributes to each object so you can do ```player.DisplayName``` or ```player.display_name```, whichever suits your fancy. 

Current Week
--------------------------

Returns the current week

```ruby 
FFNerd.current_week
```

Teams
--------------------------

```ruby
teams = FFNerd.teams
team = teams.first
team.code           # "ARI"
team.full_name      # "Arizona Cardinals"
team.short_name     # "Arizona"
```

Schedule
--------------------------

```ruby
games = FFNerd.schedule
game = games.first
game.game_date          # "2014-09-04"
game.away_team          # "GB"
home_team               # "SEA"
game_time_et            # "8:30 PM"
game.tv_station         # "NBC"
```

Players
--------------------------

Returns an array of players:

````ruby
players = FFNerd.player_list
player = players.first
player.team           # "CAR"
player.position       # "QB"
player.height         # "6-6"
player.weight         # "240"
player.dob            # "1983-06-15"
player.college        # "Oregon State"
player.player_id      # "2"
player.display_name   # "Derek Anderson"
````

Byes
---------------------------

Returns an array of teams on bye. Must pass a week between 4 and 12.

```ruby
  byes = FFNerd.byes
  bye = byes.first
  bye.team          # "ARI"
  bye.byeWeek       # "4"
  bye.displayName   # "Arizona Cardinals"
  bye.bye_week      # "4"
  bye.display_name  # "Arizona Cardinals"
```

Injuries
---------------------------

Retrieve the injury reports for each team. 
You can pass along a week number (1-17) to retrieve injuries for a specific week. Leave blank to retrieve injuries for the current week.


```ruby
injuries = FFNerd.injuries # or, e.g., FFNerd.injuries(3)
injuries = injuries.first
team_injuries.key         # "ARI"
injury = team_injuries.first
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
injury.practice_status_id # "0"
```

Auction Values
------------------------

Returns an array of fantasy auction values:

```ruby
values = FFNerd.auction_values
value = values.first
value.player_id     # "259"
value.min_price     # "54"
value.max_price     # "59"
value.avg_price     # "57"
value.display_name  # "Adrian Peterson"
```

Standard Draft Rankings
--------------------------

Returns draft rankings based on standard scoring. 

```ruby
rankings = FFNerd.standard_draft_rankings
ranking = rankings.first
ranking.player_id       # "145"
ranking.display_name    # "Jamaal Charles"
ranking.bye_week        # "6"
ranking.nerd_rank       # "1.252"
ranking.position_rank   # "1"
ranking.overall_rank    # "1"
```

PPR Draft Rankings
------------------------------

Returns draft rankings based on PPR scoring. (Turns out Jamaal Charles is the man no matter how you score it.)

```ruby
rankings = FFNerd.standard_draft_rankings
ranking = rankings.first
ranking.player_id       # "145"
ranking.display_name    # "Jamaal Charles"
ranking.bye_week        # "6"
ranking.nerd_rank       # "1.252"
ranking.position_rank   # "1"
ranking.overall_rank    # "1"
```

Draft Projections
-------------------------------

Not yet implemented. 


Weekly Projections
------------------------------
Get the weekly rankings (Both PPR and Standard)

You will need to request a specific position: QB, RB, WR, TE, K, DEF. You will also need to send along the specific week number (1-17) you'd like as well. You can optionally send along a "1" if you'd like PPR results returned.

*Need to fix this to work with PPR*

Tests
------------------
The gem includes RSpec tests and uses VCR to cache http responses. If you're going to update it, please write some. 

Contributors
-----------------
Greg Baugues ([greg@baugues.com](mailto:greg@baugues.com))
[www.baugues.com](http://www.baugues.com)


