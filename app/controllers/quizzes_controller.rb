class QuizzesController < ApplicationController

  before_action :set_quiz, only: %i[ show edit destroy take open close submit]
  before_action :authenticate_admin!, only: %i[show edit destroy open close]
  before_action :check_tour_open, only: %i[take]
  before_action :set_tour


  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/1/edit
  def edit
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy!

    respond_to do |format|
      format.html { redirect_to tours_path, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Custom

  def submit
    selected_options = params[:selected_options]

    return if selected_options.blank?

    attempt =  current_user.attempts.new(quiz: @quiz)

    respond_to do |format|
      if attempt.save
        selected_options.each do |question_id, choice_id|
          attempt.responses.create(
            question_id: question_id,
            choice_id: choice_id
          )
        end
       format.html { redirect_to tours_path, notice: "Your answers have been submitted!" }
      else
        format.html { render :attempt, status: :unprocessable_entity }
      end
    end
  end

  def open
    if @tour.status != 'open'
      respond_to do |format|
        if @tour.update(status: :open)
          format.html { redirect_to tours_path, notice: 'Quiz is now open' }
        else
          format.html { redirect_to tours_path, notice: 'Something went wrong, try again' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to tours_path, notice: 'Quiz is already open' }
      end
    end
  end

  def close
    if @tour.status != 'closed'
      respond_to do |format|
        if @tour.update(status: :closed)
          format.html { redirect_to tours_path, notice: 'Quiz is now closed' }
        else
          format.html { redirect_to tours_path, alert: "#{@tour.errors.join(',')}", status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to tours_path, notice: 'Quiz is already closed' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.friendly.find(params[:id])
    end

    def set_tour
      @tour = @quiz.tour
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:tour_id)
    end

    def check_tour_open
      respond_to do |format|
        if @quiz.tour.status == 'closed'
          format.html { redirect_to root_path, alert: 'Sorry you missed this one, Quiz is closed' }
        elsif  @quiz.tour.status == 'pending'
          format.html { redirect_to root_path, alert: 'Hey early bird, Quiz is not yet open' }
        else
         format.html  { render :take }
        end
      end
    end
end
