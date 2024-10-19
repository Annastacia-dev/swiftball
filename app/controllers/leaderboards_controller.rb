class LeaderboardsController < ApplicationController

  before_action :set_tours, only: %i[index]
  before_action :find_leaderboard, except: %i[index]

  def index
    if params[:tour]
      @tour = Tour.friendly.find(params[:tour])
    else
      @tour = @tours.first
    end

    current_index = @tours.index(@tour)
    @next_tour = @tours[current_index - 1] if current_index && current_index > 0
    @previous_tour = @tours[current_index + 1] if current_index && current_index < @tours.size - 1

    general_leaderboard
    user_leaderboard
  end

  def invite
    respond_to do |format|
      if current_user.id == @leaderboard.creator_id
        format.html { redirect_to leaderboards_path(tab: "user"), notice: "You can’t add yourself to your own leaderboard. Nice try." }
      elsif @leaderboard.leaderboard_users.exists?(user_id: current_user.id)
        format.html { redirect_to leaderboards_path(tab: "user"), notice: "You already belong to this leaderboard" }
      else
        @leaderboard.leaderboard_users.create!(user_id: current_user.id)
        current_user.leaderboard.leaderboard_users.create!(user_id: @leaderboard.creator_id )
        format.html { redirect_to leaderboards_path(tab: "user"), notice: "You are now leaderboard buddies with #{@leaderboard.creator.username}" }
      end
    end
  end

  private

  def set_tours
    @tours = Tour.where.not(status: [:pending, :cancelled]).where.not(base: true).where.not(preapp: true).order(number: :desc)
    @pagination = 20
  end

  def find_leaderboard
    @leaderboard = Leaderboard.friendly.find(params[:id])
  end

  def general_leaderboard
    @general_attempts = @tour.attempts
                             .includes(:quiz, :user, :responses)
                             .order(:final_position)

    @sorted_attempts = @general_attempts.to_a.sort_by { |attempt| [-attempt.score, attempt.created_at] }

    @paginated_attempts = @sorted_attempts.paginate(page: params[:page], per_page: @pagination)
  end

  def user_leaderboard
    users = current_user.leaderboard.leaderboard_users.includes(:user).map(&:user)
    @users_without_attempts = users.select do |user|
      !@tour.attempts.exists?(user_id: user.id)
    end
    @user_leaderboard_attempts = @tour.attempts
                       .includes(:quiz, :user, :responses)
                       .where(user_id: users.pluck(:id))
                       .order(:final_position)

    @sorted_user_attempts = @general_attempts.to_a.sort_by { |attempt| [-attempt.score, attempt.created_at] }

    @paginated_user_attempts = @sorted_attempts.paginate(page: params[:page], per_page: @pagination)
  end

end