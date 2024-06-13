class AttemptsController < ApplicationController
  before_action :authenticate_not_admin!, only: %i[index]
  before_action :set_attempt, only: %i[show edit update]
  before_action :set_quiz, only: %i[show edit update]

  def index
    @attempts = current_user.attempts.order(created_at: :desc).includes([quiz: :tour])
  end

  def show
    responses = @attempt.responses.includes(:question, :mashup_answers, choice:[image_attachment: :blob])
    ordered_questions = responses.joins(:question).order('questions.era ASC', 'questions.position ASC')
    @questions_by_era = ordered_questions.group_by { |response| response.question.era }

  end

  def update
    if @quiz.tour.status == 'open'
      responses = params[:attempt][:responses]

      responses.each do |question_id, choice_id|
        response = @attempt.responses.find_by(question_id: question_id)

        if response.update(choice_id: choice_id)
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

  private

  def set_attempt
    if current_user.admin?
      @attempt = Attempt.friendly.find(params[:id])
    else
      @attempt = current_user.attempts.friendly.find(params[:id])
    end
  end

  def set_quiz
    @quiz = @attempt.quiz
  end
end