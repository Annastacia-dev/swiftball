class NotificationWorker
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] NotificationWorker called'
    notification = Notification.find(args.first)

    return if notification.nil?

    if notification.email
      Notifications::SendEmails.call(*args)
    elsif notification.push
      Notifications::SendPush.call(*args)
    elsif
      Notifications::SendInApp.call(*args)
    end
  end
end