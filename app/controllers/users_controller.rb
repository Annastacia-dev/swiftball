class UsersController < ApplicationController

  before_action :authenticate_admin!, only: %i[index]
  before_action :find_user, only: %i[unsubscribe subscribe]

  def index
    @users = User.order(created_at: :desc).where.not(role: 'admin').paginate(page: params[:page], per_page: 10)
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
    @user = User.find(params[:id])
  end
end