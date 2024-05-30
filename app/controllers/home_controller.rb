class HomeController < ApplicationController
  def manifest
    render file: "#{Rails.root}/manifest.json", content_type: 'application/json'
  end
end