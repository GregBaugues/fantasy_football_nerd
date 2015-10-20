require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem', vcr: true do

  before :each do
    FFNerd.api_key = 'test'
  end

  it 'should retrieve teams' do
    team = FFNerd.teams.first
    expect(team.code).to eq "ARI"
    expect(team.full_name).to eq "Arizona Cardinals"
    expect(team.short_name).to eq "Arizona"
  end

  it 'should retrieve the schedule' do
    game = FFNerd.schedule.first
    expect(game.game_id).to eq "1"
    expect(game.game_week).to eq "1"
    expect(game.game_date).to eq "2013-09-05"
    expect(game.away_team).to eq "BAL"
    expect(game.home_team).to eq "DEN"
  end

  it 'should retrieve players' do
    player = FFNerd.players.first
    expect(player.player_id).to eq "2"
    expect(player.active).to eq "1"
    expect(player.jersey).to eq "3"
    expect(player.lname).to eq "Anderson"
    expect(player.fname).to eq "Derek"
    expect(player.display_name).to eq "Derek Anderson"
    expect(player.team).to eq "CAR"
    expect(player.position).to eq "QB"
    expect(player.height).to eq "6-6"
    expect(player.weight).to eq "240"
    expect(player.dob).to eq "1983-06-15"
    expect(player.college).to eq "Oregon State"
  end

  it 'should retrieve bye weeks' do
    bye = FFNerd.byes(4).first
    expect(bye.team).to eq "CAR"
    expect(bye.bye_week).to eq "4"
    expect(bye.display_name).to eq "Carolina Panthers"
  end

  it 'should retrieve injuries without a week' do
    injury = FFNerd.injuries.first
    expect(injury.week).to eq "1"
    expect(injury.player_id).to eq "0"
    expect(injury.player_name).to eq "Javier Arenas"
    expect(injury.team).to eq "ARI"
    expect(injury.position).to eq "CB"
    expect(injury.injury).to eq "Hip"
    expect(injury.practice_status).to eq "Full Practice"
    expect(injury.game_status).to eq "Probable"
    expect(injury.notes).to eq ""
    expect(injury.last_update).to eq "2013-09-09"
    expect(injury.practice_status_id).to eq 0
  end

  it 'should retrieve injuries with a week' do
    injury = FFNerd.injuries(1).first
    expect(injury.week).to eq "1"
    expect(injury.player_id).to eq "0"
    expect(injury.player_name).to eq "Javier Arenas"
    expect(injury.team).to eq "ARI"
    expect(injury.position).to eq "CB"
    expect(injury.injury).to eq "Hip"
    expect(injury.practice_status).to eq "Full Practice"
    expect(injury.game_status).to eq "Probable"
    expect(injury.notes).to eq ""
    expect(injury.last_update).to eq "2013-09-09"
    expect(injury.practice_status_id).to eq 0
  end

  it 'should retrieve auction values' do
    value = FFNerd.auction_values.first
    expect(value.player_id).to eq "259"
    expect(value.min_price).to eq "60"
    expect(value.max_price).to eq "66"
    expect(value.avg_price).to eq "63"
    expect(value.display_name).to eq "Adrian Peterson"
    expect(value.team).to eq "MIN"
    expect(value.position).to eq "RB"
  end

  it 'should retrieve the current week' do
    expect(FFNerd.current_week).to eq 17
  end

  it 'should retrieve the standard draft rankings' do
    # player 3 is where we get the first deviation between standard and ppr
    player = FFNerd.standard_draft_rankings[3]
    expect(player.playerId).to eq "1136"
    expect(player.position).to eq "RB"
    expect(player.displayName).to eq "C.J. Spiller"
    expect(player.fname).to eq "C.J."
    expect(player.lname).to eq "Spiller"
    expect(player.team).to eq "BUF"
    expect(player.byeWeek).to eq "12"
    expect(player.nerdRank).to eq "6.140"
    expect(player.positionRank).to eq "4"
    expect(player.overallRank).to eq "4"
  end

  it 'should retrieve the ppr draft rankings' do
    player = FFNerd.ppr_draft_rankings[3]
    expect(player.player_id).to eq "454"
    expect(player.position).to eq "WR"
    expect(player.display_name).to eq "Calvin Johnson"
    expect(player.fname).to eq "Calvin"
    expect(player.lname).to eq "Johnson"
    expect(player.team).to eq "DET"
    expect(player.bye_week).to eq "9"
    expect(player.nerd_rank).to eq "7.209"
    expect(player.position_rank).to eq "1"
    expect(player.overall_rank).to eq "4"
  end

  it 'should retrieve draft projections' do
    player = FFNerd.draft_projections('QB').first
    expect(player.player_id).to eq "14"
    expect(player.completions).to eq "422"
    expect(player.attempts).to eq "640"
    expect(player.passing_yards).to eq "4992"
    expect(player.passing_td).to eq "40"
    expect(player.passing_int).to eq "17"
    expect(player.rush_yards).to eq "28"
    expect(player.rush_td).to eq "1"
    expect(player.fantasy_points).to eq "335"
    expect(player.display_name).to eq "Drew Brees"
    expect(player.team).to eq "NO"
  end

  it 'should retrieve weekly rankings' do
    player = FFNerd.weekly_rankings('QB', 2).first
    expect(player.week).to eq "2"
    expect(player.player_id).to eq "14"
    expect(player.name).to eq "Drew Brees"
    expect(player.position).to eq "QB"
    expect(player.team).to eq "NO"
    expect(player.standard).to eq "24.80"
    expect(player.standard_low).to eq "18.92"
    expect(player.standard_high).to eq "32.00"
    expect(player.ppr).to eq "24.80"
    expect(player.ppr_low).to eq "18.92"
    expect(player.ppr_high).to eq "32.00"
    expect(player.injury).to be_nil
    expect(player.practice_status).to be_nil
    expect(player.game_status).to be_nil
    expect(player.last_update).to be_nil
  end

  it 'should retrieve weekly projections' do
    player = FFNerd.weekly_projections('QB', 1).first
    expect(player.week).to eq "1"
    expect(player.player_id).to eq "14"
    expect(player.position).to eq "QB"
    expect(player.pass_att).to eq "39.0"
    expect(player.pass_cmp).to eq "25.0"
    expect(player.pass_yds).to eq "317.0"
    expect(player.pass_td).to eq "2.0"
    expect(player.pass_int).to eq "1.0"
    expect(player.rush_att).to eq "1.0"
    expect(player.rush_yds).to eq "1.0"
    expect(player.rush_td).to eq "0.0"
    expect(player.fumbles_lost).to eq "0.0"
    expect(player.receptions).to eq "0.0"
    expect(player.rec_yds).to eq "0.0"
    expect(player.rec_td).to eq "0.0"
    expect(player.fg).to eq "0.0"
    expect(player.fg_att).to eq "0.0"
    expect(player.xp).to eq "0.0"
    expect(player.def_int).to eq "0.0"
    expect(player.def_fr).to eq "0.0"
    expect(player.def_ff).to eq "0.0"
    expect(player.def_sack).to eq "0.0"
    expect(player.def_td).to eq "0.0"
    expect(player.def_ret_td).to eq "0.0"
    expect(player.def_safety).to eq "0.0"
    expect(player.def_pa).to eq "0.0"
    expect(player.def_yds_allowed).to eq "0.0"
    expect(player.display_name).to eq "Drew Brees"
    expect(player.team).to eq "NO"
  end

  it 'should retrieve Flacco\'s dfs fanduel projections' do
    platform = "fanduel"
    player = FFNerd.daily_fantasy_projections(platform).first
    expect(player.player_id).to eq 35
    expect(player.position).to eq "QB"
    expect(player.name).to eq "Joe Flacco"
    expect(player.team).to eq "BAL"
    expect(player.salary).to eq "8000"
    conservative_projections = player.projections["conservative"]
    consensus_projections = player.projections["consensus"]
    aggressive_projections = player.projections["aggressive"]
    expect(conservative_projections["projected_points"]).to eq 13.6
    expect(conservative_projections["bang_for_your_buck_score"]).to eq 43.253
    expect(consensus_projections["projected_points"]).to eq 16.5
    expect(consensus_projections["bang_for_your_buck_score"]).to eq 29.385
    expect(aggressive_projections["projected_points"]).to eq 19.34
    expect(aggressive_projections["bang_for_your_buck_score"]).to eq 21.388
  end

  it 'should retrieve fanduel\'s league info' do
    platform = "fanduel"
    info = FFNerd.daily_fantasy_league_info(platform)
    expect(info.current_week).to eq "4"
    expect(info.platform).to eq "FanDuel"
    expect(info.cap).to eq 60000
    expect(info.roster_requirements).to eq({"QB" => 1, "RB" => 2, "WR" => 3,
                                            "TE" => 1, "DEF" => 1, "K" => 1, "FLEX" => 0})
    expect(info.flex_positions).to eq []
    expect(info.dev_notes).to include "The lower the Bang"
  end
end