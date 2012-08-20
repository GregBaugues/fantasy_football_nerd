Fantasy Football Nerd API
==========================

This is a Ruby Gem for the [Fantasy Football Nerd API](http://www.fantasyfootballnerd.com/api).

[Fantasy Football Nerd](http://www.fantasyfootballnerd.com) "takes the 'wisdom of the crowd' to a new level by aggregating the fantasy football rankings of the best fantasy football sites... and weighting the rankings based upon past accuracy."

Fantasy Football Nerd provides an API with access to this fantasy football data:

* Players List
* Player Details (including recent articles)
* Weekly Projections
* Injury Reports
* Preseason Draft Rankings (not currently supported)
* Season Schedule (not currently supported)


Full API access costs $9 for a season subsciption, though if you are a developer with a modicum of interest in Fantasy Football, this is the best $9 you will spend all season.


Cache your data!
----------------
Take heed to the warning on the [Fantasy Football Nerd API page](http://www.fantasyfootballnerd.com):

>The data does not generally change more than once or twice per day, so it becomes unnecessary to continually make the same calls. Please store the results locally and reference the cached responses... Your account may be suspended or API access revoked if you are found to be making excessive data calls.

Seriously, FFN is not a big operation. Don't abuse their servers.

Setup
=================
Install the gem:

        gem install fantasy-football-nerd

In plain ol' ruby, require it:

````ruby
require 'rubygems'
require 'fantasy-football-nerd'
````

In rails, add the gem to your gemfile:

````ruby
gem 'fantasy-football-nerd'
````

Set your FFN APIKey before making any calls:

````ruby
FFNerd.api_key = 123456789
````

API Resources
===================

Currently, this gem provides access to four feeds:

* Player List
* Player Detail
* Weekly Projections
* Injuries

Player List
--------------------------

````ruby
FFNerd.player_list
````

Returns an array of players with attributes:

````ruby
player.player_id
player.name
player.position
player.team
````

Player Detail
------------------------------

````ruby
player = FFNerd.player_detail(id)
````

Returns a single player with attributes:
````ruby
player.id
player.first_name
player.last_name
player.team
player.position
player.articles
````

<tt>player.articles</tt> is an array of articles:

````ruby
article = player.articles.first
article.title
article.source
article.published
````

Projections
---------------

````ruby
projections = FFNerd.projections(week)
````

Returns an array of players with attributes:
````ruby
player = projections.first
player.id
player.name
player.team
player.position
player.rank
player.projected_points #equivalent to player.projection.standard
player.projection.week
player.projection.standard
player.projection.standard_low
player.projection.standard_high
player.projection.ppr
player.projection.ppr_low
player.projection.ppr_high
````

Injuries
---------------------

````ruby
injuries = FFNerd.injuries(week)
````

Returns an array of players with attributes:

````ruby
player = injuries.first
player.id
player.name
player.team
player.position
player.injury.week
player.injury.injury_desc
player.injury.practice_status_desc
player.injury.game_status_desc
player.injury.last_update
````

Still To Come
------------------
Currently, the gem does not support these resources:

* Schedule
* Draft Rankings

Tests
------------------
The gem includes extensive RSpec tests.


Contributors
-----------------
This gem was created by:

Greg Baugues ([greg@baugues.com](mailto:greg@baugues.com))


