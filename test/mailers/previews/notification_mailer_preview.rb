class NotificationMailerPreview < ActionMailer::Preview

  def email
    user = User.first
    notification = Notification.first
    NotificationMailer.with(user_id: user.id, notification_id: notification.id).email
  end
end