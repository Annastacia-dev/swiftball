# Open Quiz Pus hNotification
# frozen_string_literal: true
require 'web-push'

module Quizzes
  class OpenPushNotification < ApplicationService
    attr_reader :quiz_id, :quiz

    def initialize(params)
      super()

      @quiz_id = params['quiz_id'] || params[:quiz_id]
    end

    def call
      find_quiz
      # find_users_without_attempt
      send_push_notification
    end

    private

    def find_quiz
      return if quiz_id.blank?

      puts 'Finding quiz...'
      @quiz = Quiz.find(quiz_id)

      if quiz.present?
        logger.info("Found #{quiz.title}")
        return true
      end

      log_error "Could not find quiz with id: #{quiz_id}"
      false
    end

    def send_push_notification
      subscriptions = PushSubscription.all
      subscriptions.each do |subscription|
        payload = {
          title: "#{quiz.title.titleize} is Open!",
          body: "Make your predictions before #{quiz.tour.quiz_live_time.strftime("%A %d %B %Y %H:%M")}",
          icon: '/icon-96.png',
          badge: '/icon-96.png',
          url: take_quiz_url(quiz)
        }
        send_push_to_subscription(subscription, payload)
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