Rack::Attack.throttle("api/ip", limit: 300, period: 5.minutes) do |req|
  req.ip
end

Rack::Attack.throttle("auth/ip", limit: 10, period: 3.minutes) do |req|
  req.ip if req.path.start_with?("/auth/login") && req.post?
end
