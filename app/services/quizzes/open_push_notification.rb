# Open Quiz Push hNotification
# frozen_string_literal: true
require 'web-push'

module Quizzes
  class OpenPushNotification < ApplicationService
    include QuizConcern

    def initialize(params)
      super()

      @quiz_id = params['quiz_id'] || params[:quiz_id]
    end

    def call
      find_quiz
      find_users_without_attempt
      send_push_notification
    end

    private

    def send_push_notification
      return if users_without_attempt.blank?

      subscriptions = users_without_attempt.map(&:push_subscriptions).flatten

      if subscriptions.present?
        subscriptions.each do |subscription|
          user = subscription.user
          payload = {
            title: "#{quiz.title.titleize} Swiftball is Open!",
            body: "Make your predictions before #{quiz.tour&.quiz_live_time.in_time_zone(user.timezone).strftime("%A %d %B %Y %H:%M")}",
            icon: '/icon-96.png',
            badge: '/icon-96.png',
            url: take_quiz_url(quiz)
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
end