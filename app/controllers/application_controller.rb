class ApplicationController < ActionController::Base
  before_action :set_variables
  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone, if: :current_user
  before_action :set_data_details, if: :current_user


  private

  def set_time_zone
    Time.zone = current_user.timezone if current_user.timezone.present?
  end

  def set_data_details
    @unread_notifications_total = current_user.notifications.where(status: :unread).size
    @unread_feedback_total = Feedback.where(status: :unread).size
  end

  def authenticate_admin!
    if !current_user.admin?
      respond_to do |format|
      format.html  { redirect_to root_path, alert: 'You are not authorized to access this' }
      end
    end
  end

  def authenticate_not_admin!
    if current_user.admin?
      respond_to do |format|
      format.html  { redirect_to root_path, alert: "Admin users can't access this" }
      end
    end
  end

  def set_variables
    @timezones = ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.identifier] }.sort
    @country_options_for_select = ISO3166::Country.all.map { |country| [country.iso_short_name, country.iso_short_name] }.sort
    @albums = Album.where(status: :active).order(:created_at).map { |album| [album.title, album.id] }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username timezone country terms_and_conditions])
  end
end
