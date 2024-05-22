class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy attempt_quiz attempt ]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:tour_id)
    end
end
