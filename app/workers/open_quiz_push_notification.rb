# Worker to send push notifications when a quiz is opened
class OpenQuizPushNotification
  include Sidekiq::Worker

  def perform(params)
    logger.info '[Worker] OpenQuizPushNotification started'

    Quizzes::OpenPushNotification.call(params)
  end
end