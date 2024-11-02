class Leaderboards::User < ApplicationService

  attr_reader :current_user

  def initialize(params)
    super()
    @tour = Tour.find(params[:tour_id] || params['tour_id'])
    @current_user = User.find(params[:user_id] || params['user_id'])
  end

  def call
    logger.info '[Service] Leaderboards::User called'

    load_attempts
    {
      sorted_attempts: @sorted_attempts,
      users_without_attempts: @users_without_attempts
    }
  end

  private

  def load_attempts
    users = current_user.leaderboard.leaderboard_users.includes(:user).map(&:user)
    @users_without_attempts = users.select do |user|
      !@tour.attempts.exists?(user_id: user.id)
    end
    @user_leaderboard_attempts = @tour.attempts
                       .includes(:quiz, :user)
                       .where(user_id: users.pluck(:id))

    if @tour.status == 'closed'
      @sorted_attempts = @user_leaderboard_attempts.order(final_score: :desc)
    else
      @sorted_attempts = @user_leaderboard_attempts.to_a.sort_by { |attempt| [-attempt.score, attempt.created_at] }
    end
  end
end