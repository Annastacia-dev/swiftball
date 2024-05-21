class ApplicationController < ActionController::Base
  before_action :set_variables
  before_action :set_paper_trail_whodunnit
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_variables
    @timezones = ActiveSupport::TimeZone.all.map { |tz| [tz.tzinfo.identifier] }.sort
    @country_options_for_select = ISO3166::Country.all.map { |country| [country.iso_short_name, country.iso_short_name] }.sort
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username timezone country terms_and_conditions])
  end
end
