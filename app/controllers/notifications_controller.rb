class NotificationsController < ApplicationController

  before_action :authenticate_admin!, only: %i[new create edit update destroy]
  before_action :find_notification, except: %i[index new create]

  def index
    @notifications = current_user.notifications.where(in_app: true).order(created_at: :desc)
  end

  def new
    @notification = Notification.new
  end

  def show
    respond_to do |format|
      if @notification.update(status: 'read')
        if @notification.link
          format.html { redirect_to @notification.link}
        else
          format.html { redirect_to notifications_path }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        send_notification
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
    params.require(:notification).permit(:subject, :message, :email, :push, :in_app, :link, :link_test)
  end

  def send_notification
    NotificationWorker.perform_async(@notification.id)
  end
end