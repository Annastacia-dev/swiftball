class GoLiveQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] GoLiveQuiz called'
  end

  private
end