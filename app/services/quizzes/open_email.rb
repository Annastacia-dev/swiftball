# Open Quiz Email
# frozen_string_literal: true

module Quizzes
  class OpenEmail < ApplicationService
    include QuizConcern


    def initialize(params)
      super()

      @quiz_id = params['quiz_id'] || params[:quiz_id]
    end

    def call
      find_quiz
      find_users_without_attempt
      send_email
    end

    private

    def send_email
      return if users_without_attempt.blank?

      users_without_attempt.each do |user|
        if user.notify_me
          QuizMailer.with(user_id: user.id, quiz_id: quiz.id)
                  .open
                  .deliver_later(wait: 2.seconds)
        end
      end
    end

  end
end