# Worker to send email when a quiz is opened
class OpenQuizEmail
  include Sidekiq::Worker

  def perform(params)
    logger.info '[Worker] OpenQuizEmail started'

    Quizzes::OpenEmail.call(params)
  end
end