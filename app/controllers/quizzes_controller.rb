class QuizzesController < ApplicationController

  before_action :set_quiz, only: %i[ show edit destroy attempt_quiz attempt open_quiz close_quiz ]
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

  def attempt_quiz
    @attempt = current_user.attempts.new({
      quiz_id: @quiz.id
    })

    respond_to do |format|
      if @attempt.save
        format.html { redirect_to attempt_path(@attempt) }
      else
        format.html { redirect_to tours_path, alert: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  def open_quiz
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

  def close_quiz
    if @tour.status != 'closed'
      respond_to do |format|
        if @tour.update(status: :closed)
          format.html { redirect_to tours_path, notice: 'Quiz is now closed' }
        else
          format.html { redirect_to tours_path, notice: 'Something went wrong, try again' }
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
end
