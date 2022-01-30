class Rack::Attack

  throttle('req/ip short', :limit => 15, :period => 1.second) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  throttle('req/ip mid', :limit => 360, :period => 3.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  throttle('request dist', :limit => 15000, :period => 10.minutes) do |req|
  end

end
