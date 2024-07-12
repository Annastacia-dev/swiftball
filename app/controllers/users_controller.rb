class UsersController < ApplicationController

  before_action :authenticate_admin!, only: %i[index]
  before_action :find_user, only: %i[unsubscribe subscribe show]

  def index
    @users = User.order(created_at: :desc).where.not(role: 'admin').paginate(page: params[:page], per_page: 10)

    @users_by_country = User.where.not(role: 'admin').order(:country).group(:country).count


    @chart_data = @users_by_country.map do |country, count|
      [country, count]
    end
  end

  def show
    @attempts = @user.attempts
    @current_streak = @user.current_streak
    @max_streak = @user.max_streak
    attempts_count = @user.attempts.size

    attempts_for_average = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }

    @average_score = attempts_for_average.size.zero? ? 0 : attempts_for_average.map(&:score).sum.to_i / attempts_for_average.size
    @lifetime_points = attempts_for_average.map(&:score).sum
    @best_score = attempts_for_average.map(&:score).max || 0
  end

  def unsubscribe
    respond_to do |format|
      if @user.notify_me == false
        format.html { redirect_to root_path, notice: "You are already unsubscribed from email notifications." }
      else
        if @user.update(notify_me: false)
          format.html { redirect_to root_path, notice: "You were successfully unsubscribed from email notifications." }
        else
          format.html { redirect_to root_path, alert: "Something went wrong" }
        end
      end
    end
  end

  def subscribe
    respond_to do |format|
      if @user.notify_me == true
        format.html { redirect_to root_path, notice: "You are already subscribed to email notifications." }
      else
        if @user.update(notify_me: true)
          format.html { redirect_to root_path, notice: "You have successfully subscribed to email notifications." }
        else
          format.html { redirect_to root_path, alert: "Something went wrong" }
        end
      end
    end
  end

  private

  def find_user
    @user = User.friendly.find(params[:id])
  end
end