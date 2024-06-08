class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ terms_and_conditions privacy_policy manifest]

  def manifest
    render file: "#{Rails.root}/manifest.json", content_type: 'application/json'
  end

  def stats
    @user = current_user.admin? ? User.find(params[:id]) : current_user
    @attempts = @user.attempts
    @current_streak = @user.current_streak
    @max_streak = @user.max_streak
    attempts_count = @user.attempts.size

    attempts_for_average = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }

    @average_score = attempts_count.zero? ? 0 : attempts_for_average.map(&:score).sum.to_i / attempts_count
    @lifetime_points = attempts_for_average.map(&:score).sum
    @best_score = attempts_for_average.map(&:score).max || 0
  end

  def leaderboard
    @tours = Tour.where.not(status: :pending).where.not(base: true).order(number: :desc)
    @users = User.where.not(role: :admin)
    if params[:tour]
      @tour = Tour.friendly.find(params[:tour])
    else
      @tour = @tours.first
    end

    current_index = @tours.index(@tour)
    @next_tour = @tours[current_index - 1] if current_index && current_index > 0
    @previous_tour = @tours[current_index + 1] if current_index && current_index < @tours.size - 1

    @attempts = Attempt.where(quiz_id: @tour.quiz.id).sort_by { |attempt| -attempt.score }
  end
end