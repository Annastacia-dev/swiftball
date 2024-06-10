class UsersController < ApplicationController

  before_action :authenticate_admin!

  def index
    @users = User.order(created_at: :desc).where.not(role: 'admin').paginate(page: params[:page], per_page: 10)
  end
end