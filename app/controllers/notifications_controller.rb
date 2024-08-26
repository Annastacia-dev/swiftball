class NotificationsController < ApplicationController

  before_action :authenticate_admin!, only: %i[new create edit update destroy]
  before_action :find_notification, except: %i[new create]

  def index
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to notifications_path, notice: 'Notification was created successfully.'}
      else
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end


  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to notifications_path, notice: 'Notification was created successfully.'}
      else
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @notification.destroy!

    respond_to do |format|
      format.html { redirect_to notifications_path, notice: "Notification was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def find_notification
    @notification = Notification.find(params[:id])
  end

  def notification_params
    params.require(:notification).permit(:subect, :message, :email, :push, :in_app)
  end
end