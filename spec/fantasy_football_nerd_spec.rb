require_relative 'spec_helper.rb'
require_relative '../lib/fantasy_football_nerd.rb'

describe 'Fantasy Football Nerd Gem' do

  before :each do
    FFNerd.load_settings
  end

  describe 'settings' do
    it 'should retrieve settings from settings.yml' do
      FFNerd.api_key.should_not be_nil
    end
  end

  describe 'feed_url' do
    it 'should generate a url for feeds with an api key' do
      FFNerd.feed_url(:schedule).should       =~ /ffnScheduleXML.php/
      FFNerd.feed_url(:projections).should    =~ /ffnSitStartXML.php/
      FFNerd.feed_url(:injuries).should       =~ /ffnInjuriesXML.php/
      FFNerd.feed_url(:all_players).should    =~ /ffnPlayersXML.php/
      FFNerd.feed_url(:player).should         =~ /ffnPlayerDetailsXML.php/
      FFNerd.feed_url(:schedule).should       =~ /apiKey=\d+/
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
# Current Week
#############################################################################

  describe '#current_week' do
    context 'when in season' do
      it 'returns the current week number' do
        Timecop.freeze(2013,9,8)
        expect(FFNerd.current_week).to eq(1)
        Timecop.return
      end
    end

    context 'before the season starts' do
      it 'raises an error that the season has not yet started' do
        Timecop.freeze(2013,9,1)
        expect { FFNerd.current_week }.to raise_error "The NFL season has not yet started."
        Timecop.return
      end
    end

    context 'when the season is over' do
      it 'raises an error that the season is over' do
        Timecop.freeze(2013,12,31)
        expect { FFNerd.current_week }.to raise_error "The regular NFL season is over."
        Timecop.return
      end
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
  # Current Week
  # Returns the current week of the season
  #############################################################################

  describe 'Current Week' do

    it 'should return the current week of the NFL season' do
      date = Date.parse('2012-9-14')
      Date.stub(:today).and_return(date)
      FFNerd.current_week.should == 2
    end

    it 'Monday should still be considered the previous week' do
      date = Date.parse('2012-9-10')
      Date.stub(:today).and_return(date)
      FFNerd.current_week.should == 1
    end
  end

end
