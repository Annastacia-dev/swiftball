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

    subscriptions = User.all.map(&:push_subscriptions).flatten.uniq

      if subscriptions.present?
        subscriptions.each do |subscription|
          user = subscription.user
          payload = {
            title: notification.subject,
            body: notification.message.gsub(/<\/?[^>]+>/, ""),
            icon: '/icon-96.png',
            badge: '/icon-96.png',
            url: notification.link
          }
          logger.info "Sending Push notification to #{user.username}"
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
  rescue WebPush::InvalidSubscription, WebPush::ExpiredSubscription => e
    subscription.destroy
    Rails.logger.error "Failed to send push notification and destroyed the subscription: #{e.message}"
  rescue StandardError => e
    Rails.logger.error "Unexpected error when sending push notification: #{e.message}"
  end
end