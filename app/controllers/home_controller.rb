class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ terms_and_conditions privacy_policy manifest]

  def manifest
    render file: "#{Rails.root}/manifest.json", content_type: 'application/json'
  end

  def stats
    @attempts = current_user.attempts
    @average_score = current_user.attempts.includes([:quiz, :responses]).map(&:score).sum.to_i / current_user.attempts.size rescue nil
    @average_position = current_user.attempts.map(&:position).sum.to_i / current_user.attempts.size rescue nil
  end
end