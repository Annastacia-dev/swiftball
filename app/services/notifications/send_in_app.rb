class Notifications::SendInApp < ApplicationService

  attr_reader :notification

  def initialize(params)
    super()
    @notification = Notification.find(params)
  end

  def call
    logger.info '[Service] Notification::SendInApp called'

    create_notifications
  end

  private

  def create_notifications
    return if notification.nil?

    User.all.each do |user|

      logger.info "Creating notification for #{user.username}"

      new_notification = notification.dup
      new_notification.user = user
      new_notification.save
    end
  end
end