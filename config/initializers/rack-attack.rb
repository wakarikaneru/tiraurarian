class Rack::Attack



  throttle('request dist', :limit => 15000, :period => 10.minutes) do |req|
    # IPを問わない
    req
  end

end
