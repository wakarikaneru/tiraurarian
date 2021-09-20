class Rack::Attack

  throttle('req/ip', :limit => 15, :period => 1.second) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end

  throttle('req/ip', :limit => 360, :period => 3.minutes) do |req|
    req.ip # unless req.path.start_with?('/assets')
  end
end
