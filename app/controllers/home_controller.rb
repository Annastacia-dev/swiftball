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
    @average_score = attempts_count.zero? ? 0 : @user.attempts.includes([:quiz, :responses]).map(&:score).sum.to_f / attempts_count
    @average_position = attempts_count.zero? ? 0 : @user.attempts.map(&:position).sum.to_f / attempts_count
  end
end