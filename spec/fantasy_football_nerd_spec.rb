require 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem' do
  before (:each) do
    FFNerd.api_key = '123456789'
  end

  describe 'feed_url' do
    it 'should generate a url for feeds with an api key' do
      FFNerd.feed_url(:schedule).should       =~ /ffnScheduleXML.php/
      FFNerd.feed_url(:projections).should    =~ /ffnSitStartXML.php/
      FFNerd.feed_url(:injuries).should       =~ /ffnInjuriesXML.php/
      FFNerd.feed_url(:all_players).should    =~ /ffnPlayersXML.php/
      FFNerd.feed_url(:player).should         =~ /ffnPlayerDetailsXML.php/
      FFNerd.feed_url(:schedule).should       =~ /apiKey=\d+/
      FFNerd.feed_url(:rankings).should       =~ /ffnRankingsXML.php/
    end

    it 'should take parameters' do
      url = FFNerd.feed_url(:schedule, week: 12)
      url.should =~ /&week=12/
    end
  end

  #############################################################################
  # Resource Retrieval Helpers
  #############################################################################

  describe 'url builders' do
    it 'should get a url for details on a specific player' do
      url = FFNerd.player_url(13)
      url.should =~ /ffnPlayerDetailsXML.php\?apiKey=\d+&playerId=13/
    end

    it 'should get a url for a week\'s projections' do
      url = FFNerd.projections_url(:all, 1)
      url.should =~ /ffnSitStartXML.php\?apiKey=\d+&week=1&position=ALL/
    end

    it 'should get an injury url' do
      url = FFNerd.injuries_url(1)
      url.should =~ /ffnInjuriesXML.php\?apiKey=\d+&week=1/
    end

    it 'should get a list of all players' do
      url = FFNerd.player_list_url
      url.should =~ /ffnPlayersXML.php\?apiKey=\d+/
    end

    it 'should get a url for rankings of only qb position' do
      url = FFNerd.rankings_url(:qb, 10, false,false)
      url.should =~ /ffnRankingsXML.php\?apiKey=\d+&position=QB&sos=0&limit=10/
    end
  end


  it 'should return a resource' do
    VCR.use_cassette('player_list') do
      url = FFNerd.player_list_url
      FFNerd.get_resource(url).should be_true
    end
  end
  #############################################################################
  # Player Detail
  #############################################################################

  it 'should get player detail' do
    VCR.use_cassette('player_detail') do
      player = FFNerd.player_detail(13)
      player.first_name.should == "Tom"
      player.last_name.should  == "Brady"
      player.team.should       == "NE"
      player.position.should   == "QB"
      player.articles.first.published.should == Date.new(2012, 8, 10)
    end
  end

  it 'should get player articles' do
    VCR.use_cassette('player_detail') do
      url = FFNerd.player_url(13)
      player_doc = FFNerd.get_resource(url)
      articles = FFNerd.parse_articles(player_doc)
      articles.should be_a Array
      articles.first.title.should == "New England Patriots best New Orleans Saints, 7-6"
      articles.first.source.should == "http://www.nfl.com/goto?id=0ap2000000048294"
      articles.first.published.should == Date.new(2012, 8, 10)
    end
  end

#############################################################################
# Injuries
#############################################################################

  it 'should get player data from the injury feed' do
    VCR.use_cassette('injuries') do
      player = FFNerd.injuries(1).first
      test_values(player,
        id: 1242,
        name: 'Alfonso Smith',
        team: 'ARI',
        position: 'RB'
      )
    end
  end

  it 'should get injury data from the injury feed' do
    VCR.use_cassette('injuries') do
      player = FFNerd.injuries(1).first
      test_values(player.injury,
        week: 1,
        injury_desc: 'Hamstring',
        practice_status_desc: 'Full Practice',
        game_status_desc: 'Good chance to play',
        last_update: Date.parse('2011-09-12')
      )
    end
  end

#############################################################################
# Player List
#############################################################################

  it 'player_list should return player data' do
    VCR.use_cassette('player_list') do
      players = FFNerd.player_list
      players.size.should == 1170
      test_values(players.first,
        name: "Derek Anderson",
        position: "QB",
        team: "CAR",
        id: 2
      )
    end
  end

#############################################################################
# Projections
#############################################################################

  it 'should retrieve player data from the projection feed' do
    VCR.use_cassette('projections') do
      projections = FFNerd.projections(3, :all)
      player = projections.first
      test_values(player,
        name:             "Ray Rice",
        projected_points: 19.60,
        team:             "BAL",
        position:         "RB",
        id:               269,
        rank:             1
      )
    end
  end

  it 'should retrieve projection data from the projection feed' do
    VCR.use_cassette('projections') do
      player = FFNerd.projections(3).first
      test_values(player.projection,
        week:             3,
        standard:         19.60,
        standard_low:     15.60,
        standard_high:    27.20,
        ppr:              22.10,
        ppr_low:          18.25,
        ppr_high:         31.20
      )
    end
  end

  #############################################################################
  # Master Player Method
  # Combines injury and projection data into a single call
  #############################################################################

  describe 'Master Player Method' do

    it 'should combine injury and projection data' do
      with_stub_feeds do
        player = FFNerd.players(1).first
        player.position.should == 'RB'
        player.injured.should be_true
        player.projection.standard.should == 26
      end
    end

  end
  #############################################################################
  # Schedule
  # API call for NFL season schedule data
  #############################################################################
  describe 'Schedule Method' do
    it 'should get the schedule for a particular week' do
      VCR.use_cassette('schedule') do
        schedule = FFNerd.schedule(5)
        schedule.size.should == 14
        schedule.each do |game|
          game.week.should == 5
        end
      end
    end

    it 'should get the schedule for whole season if no week specified' do
      VCR.use_cassette('schedule') do
        schedule = FFNerd.schedule
        schedule.size.should == 256  # 16 teams play 16 games.
      end
    end

  end

  #############################################################################
  # Preseason Draft Rankings
  # API call for preseason rankings of players
  #############################################################################

  describe 'PPR Rankings Method' do

    it 'should get PPR-scoring rankings' do
      VCR.use_cassette('rankings') do
        FFNerd.api_key = 2012120677595038
        rankings = FFNerd.ppr_rankings
        rankings.size.should == 15
      end
    end

    it 'should get PPR-scoring rankings of specified positions' do
      VCR.use_cassette('rankings', :record => :new_episodes) do
        FFNerd.api_key = 2012120677595038
        qb_rankings = FFNerd.ppr_rankings(:qb)
        qb_rankings.size.should == 15
        qb_rankings.each do |ranking|
          ranking.player_position.should == 'QB'
        end
      end
    end

 end

  describe 'Standard Rankings Method' do
    it 'should get standard-scoring rankings' do
      VCR.use_cassette('rankings', :record => :new_episodes) do
        FFNerd.api_key = 2012120677595038
        rankings = FFNerd.standard_rankings
        rankings.size.should == 15
      end

    end

    it 'should get standard-scoring rankings of specified positions' do
      VCR.use_cassette('rankings', :record => :new_episodes) do
        FFNerd.api_key = 2012120677595038
        rankings = FFNerd.standard_rankings
        rankings.size.should == 15
      end
    end
  end
end
