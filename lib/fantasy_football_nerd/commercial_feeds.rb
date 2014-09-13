module CommercialFeeds

  def player_info(id)
    raise 'You must pass along a player id' if id.nil?
    data = request_service('player', FFNerd.api_key, id)
    OpenStruct.new(data['Player'].add_snakecase_keys)
  end

  def player_stats(id)
    data = request_service('player', FFNerd.api_key, id)
    data = data['Stats']
    data.change_keys_to_ints
    data.each do |year, weeks|
      weeks.each do |week, stats|
        stats.change_keys(new_keys)
        stats.add_snakecase_keys
        stats.change_string_values_to_floats
        weeks[week] = OpenStruct.new(stats)
      end
    end
    data
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