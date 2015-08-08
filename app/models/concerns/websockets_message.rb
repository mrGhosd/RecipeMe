module WebsocketsMessage

  def message(msg)
    $redis.publish 'rtchange', msg.to_json
  end

end