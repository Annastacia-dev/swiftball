class AttemptsController < ApplicationController
  before_action :set_attempt, only: %i[show]

  def show
    @quiz = @attempt.quiz
    @questions_by_era = @attempt.responses.group_by { |response| response.question.era }
  end

  private

  def set_attempt
    @attempt = current_user.attempts.find(params[:id])
  end
end