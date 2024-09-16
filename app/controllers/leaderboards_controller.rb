class LeaderboardsController < ApplicationController

  before_action :set_tours, only: %i[index]

  def index
    if params[:tour]
      @tour = Tour.friendly.find(params[:tour])
    else
      @tour = @tours.first
    end

    current_index = @tours.index(@tour)
    @next_tour = @tours[current_index - 1] if current_index && current_index > 0
    @previous_tour = @tours[current_index + 1] if current_index && current_index < @tours.size - 1

    if params[:tab] == 'general'
      general_leaderboard
    else
      user_leaderboard
    end
  end

  private

  def set_tours
    @tours = Tour.where.not(status: [:pending, :cancelled]).where.not(base: true).where.not(preapp: true).order(number: :desc)
    @pagination = 20
  end

  def general_leaderboard
    @general_attempts = @tour.attempts
                     .includes(:quiz, :user, :responses)
                     .order(:final_position)
                     .paginate(page: params[:page], per_page: @pagination)
  end

  def user_leaderboard
    users = current_user.leaderboard.leaderboard_users.includes(:user).map(&:user)
    @user_leaderboard_attempts = @tour.attempts
                       .includes(:quiz, :user, :responses)
                       .where(user_id: users.pluck(:id))
                       .order(:final_position)
                       .paginate(page: params[:page], per_page: @pagination)
  end

end