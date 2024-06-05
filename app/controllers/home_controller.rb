class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ terms_and_conditions privacy_policy manifest]

  def manifest
    render file: "#{Rails.root}/manifest.json", content_type: 'application/json'
  end

  def stats
    @attempts = current_user.attempts
  end
end