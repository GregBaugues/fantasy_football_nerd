module CommercialFeeds

  def player(id)
    raise 'You must pass along a player id' if id.nil?
    data = request_service('player', FFNerd.api_key, id)
    OpenStruct.new(data['Player'].add_snakecase_keys)
  end
end