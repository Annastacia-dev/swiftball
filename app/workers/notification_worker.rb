class NotificationWorker
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] NotificationWorker called'
    notification = Notification.find(args.first)

    return if notification.nil?

    if notification.email
      Notifications::SendEmail.call(*args)
    end

    if notification.in_app
      Notifications::SendInApp.call(*args)
    end

    if notification.push
      Notifications::SendPush.call(*args)
    end
  end
end