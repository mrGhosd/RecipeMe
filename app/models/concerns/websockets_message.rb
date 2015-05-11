module WebsocketsMessage

  def message(msg)
    $redis.publish 'rt-change', msg.to_json
  end

end