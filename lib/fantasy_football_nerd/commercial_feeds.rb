module CommercialFeeds

  def player_info(id)
    raise 'You must pass along a player id' if id.nil?
    data = request_service('player', FFNerd.api_key, id)
    OpenStruct.new(data['Player'].add_snakecase_keys)
  end

  def player_stats(id)
    raise 'You must pass along a player id' if id.nil?
    data = request_service('player', FFNerd.api_key, id)
    data = data['Stats']
    data.change_keys_to_ints
    data.each do |year, weeks|
      weeks.each { |week, stats| weeks[week] = create_stats_ostruct(stats) }
    end
    data
  end

  def daily_fantasy_projections(dfs_platform)
    raise "You must pass along a valid dfs platform (#{DFS_PLATFORMS})" unless DFS_PLATFORMS.include?(dfs_platform)
    ostruct_request('daily', 'players', [dfs_platform])
  end

  def daily_fantasy_league_info(dfs_platform)
    raise "You must pass along a valid dfs platform (#{DFS_PLATFORMS})" unless DFS_PLATFORMS.include?(dfs_platform)
    data = request_service('daily', api_key, dfs_platform)
    OpenStruct.new(current_week: data["week"], cap: data["cap"],
                   platform: data["platform"], roster_requirements: data["rosterRequirements"],
                   flex_positions: data["flexPositions"], dev_notes: data["developerNotes"])
  end

  def create_stats_ostruct(stats)
    stats.change_string_values_to_floats
    stats.change_keys(new_keys)
    stats.add_snakecase_keys
    OpenStruct.new(stats)
  end

  def new_keys
    {
      'passAttempts' => 'passAtt',
      'passYards' => 'passYds',
      'avgPassYards' => 'avgPassYds',
      'passYards' => 'passYds',
      'Sacks' => 'sacks',
      'SackYards' => 'sackYds',
      'QBRating' => 'qb_rating',
      'rushAttempts' => 'rushAtt',
      'rushYards' => 'rushYds',
      'recYards' => 'recYds',
      'fumble' => 'fumbles',
      'fumbleLost' => 'fumblesLost'
    }
  end

  def is_float_stat?(stat_name)
    !['final_score', 'opponent', 'date'].include?(stat_name)
  end
end