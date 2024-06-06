class CloseQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] CloseQuiz called'
  end

  private
end