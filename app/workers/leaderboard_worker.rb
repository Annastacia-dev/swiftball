class LeaderboardWorker
  include Sidekiq::Worker

  def perform(tour_id)
    logger.info '[Worker] LeaderboardWorker called'
    sorted_attempts = Leaderboards::General.call({ 'tour_id' => tour_id })
    
    # Store the result in Redis
    $redis.set("leaderboard_#{tour_id}", sorted_attempts.to_json)
  end
end
