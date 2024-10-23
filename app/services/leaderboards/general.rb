class Leaderboards::General < ApplicationService

  attr_reader :notification

  def initialize(params)
    super()
    @tour = Tour.find(params[:tour_id] || params['tour_id'])
  end

  def call
    logger.info '[Service] Leaderboards::General called'

    load_attempts
    @sorted_attempts
  end

  private

  def load_attempts
    @general_attempts = @tour.attempts
                             .includes(:quiz, :user, :responses)
                             .order(:final_position)

    @sorted_attempts = @general_attempts.to_a.sort_by { |attempt| [-attempt.score, attempt.created_at] }
  end
end