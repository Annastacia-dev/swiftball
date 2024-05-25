class AttemptsController < ApplicationController
  before_action :set_attempt, only: %i[show edit update]
  before_action :set_quiz, only: %i[show edit update]

  def show
    @questions_by_era = @attempt.responses.group_by { |response| response.question.era }
  end

  def update
    if @quiz.tour.status == 'open'
      responses = params[:attempt][:responses]

      responses.each do |question_id, choice_id|
        response = @attempt.responses.find_by(question_id: question_id)

        if response.update(choice_id: choice_id)
          update_mashup_answer(response)
          next
        else
          redirect_to attempt_path(@attempt), alert: "Something went wrong. Please try again."
          return
        end
      end

      redirect_to attempt_path(@attempt), notice: "Your answers have been updated!"
    elsif @quiz.tour.status == 'closed'
      redirect_to attempt_path(@attempt), alert: "Sorry this quiz has been closed!"
    end
  end

  def update_mashup_answer(response)
  end

  private

  def set_attempt
    @attempt = current_user.attempts.friendly.find(params[:id])
  end

  def set_quiz
    @quiz = @attempt.quiz
  end
end