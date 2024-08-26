require 'web-push'

class Notifications::SendPush < ApplicationService

  attr_reader :notification

  def initialize(params)
    super()
    @notification = Notification.find(params)
  end

  def call
    logger.info '[Service] Notification::SendPush called'

    send_push_notifications
  end

  private

  def send_push_notifications
    return if notification.nil?
    byebug
    subscriptions =User.all.map(&:push_subscriptions).flatten

      if subscriptions.present?
        subscriptions.each do |subscription|
          user = subscription.user
          payload = {
            title: notification.subject,
            body: notification.message,
            icon: '/icon-96.png',
            badge: '/icon-96.png',
            url: notification.link
          }
          send_push_to_subscription(subscription, payload)
        end
      else
        logger.info 'No user is subscribed to push notifications'
      end
  end

  def send_push_to_subscription(subscription, payload)
    WebPush.payload_send(
      message: JSON.generate(payload),
      endpoint: subscription.endpoint,
      p256dh: subscription.keys['p256dh'],
      auth: subscription.keys['auth'],
      vapid: {
        public_key: ENV.fetch('VAPID_PUBLIC_KEY'),
        private_key: ENV.fetch('VAPID_PRIVATE_KEY')
      },
      ssl_timeout: 5,
      open_timeout: 5,
      read_timeout: 5
    )
  rescue WebPush::InvalidSubscription => e
    Rails.logger.error "Failed to send push notification: #{e.message}"
  end
end