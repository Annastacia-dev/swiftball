# frozen_string_literal: true

class ApplicationService
  include Rails.application.routes.url_helpers

  attr_accessor :errors
  attr_reader :logger

  def initialize
    @errors = []
    @logger = Rails.logger
  end

  def log_error(error)
    stringed_error = error.to_s
    logger.error stringed_error
    errors << stringed_error
  end

  def self.call(...)
    new(...).call
  end

  class Result
    attr_reader :model, :errors

    def initialize(success:, model:, errors: nil)
      @model = model
      @success = success
      @errors = errors
    end

    def success?
      @success
    end
  end

  private_constant :Result
end
