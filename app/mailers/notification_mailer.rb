class NotificationMailer < ApplicationMailer
  helper ApplicationHelper

  def email
    @notification = Notification.find(params[:notification_id])
    @user = User.friendly.find(params[:user_id])
    @message = @notification.message
    subject = @notification.subject

    mail(
      subject: subject,
      to: @user.email
    )
  end
end
