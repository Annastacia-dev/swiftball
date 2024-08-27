class Notifications::SendEmail < ApplicationService

  attr_reader :notification

  def initialize(params)
    super()
    @notification = Notification.find(params)
  end

  def call
    logger.info '[Service] Notification::SendEmail called'

    send_emails
  end

  private

  def send_emails
    return if notification.nil?

    User.all.each do |user|
      if user.notify_me
        logger.info "Sending email to #{user.username} - #{user.email}"
        NotificationMailer.with(user_id: user.id, notification_id: notification.id)
                .email
                .deliver_later(wait: 2.seconds)
      end
    end
  end
end
