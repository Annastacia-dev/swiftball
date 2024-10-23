$redis = Redis.new(url: ENV['REDISCLOUD_URL'] || "redis://localhost:6379/0")
