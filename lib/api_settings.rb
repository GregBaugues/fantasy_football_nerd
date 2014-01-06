module APISettings

  def season_start_date
    Date.new(2013,9,3)
  end

  def base_url
    "http://api.fantasyfootballnerd.com"
  end

  def feeds
    {
      schedule:     "ffnScheduleXML.php",
      projections:  "ffnSitStartXML.php",
      injuries:     "ffnInjuriesXML.php",
      all_players:  "ffnPlayersXML.php",
      player:       "ffnPlayerDetailsXML.php"
    }
  end

  module_function :season_start_date, :base_url, :feeds
end
