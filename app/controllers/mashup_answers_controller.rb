class MashupAnswersController < ApplicationController

  before_action :find_response
  before_action :find_mashup_answer, only: %i[edit update destroy]
  before_action :set_question, only: %i[edit update destroy]

  def index
    @mashup_answers = @response.mashup_answers
    respond_to do |format|
      format.html { render :index }
      format.json {render json: @mashup_answers }
    end
  end

  def edit
  end

  def update
    path = current_user.admin? ? quiz_path(@question.quiz) : edit_attempt_path(@mashup_answer.response.attempt)
    respond_to do |format|
      if @mashup_answer.update(mashup_params)
        format.html { redirect_to path, notice: "Mashup Answer was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mashup_answer.destroy!

    path = current_user.admin? ? quiz_path(@question.quiz) : edit_attempt_path(@mashup_answer.response.attempt)

    respond_to do |format|
      format.html { redirect_to path, notice: "Answer was successfully deleted." }
      format.json { head :no_content }
    end
  end


  private

  def find_response
    if params[:response_id]
      @response = Response.find(params[:response_id])
    end
  end

  def find_mashup_answer
    @mashup_answer = MashupAnswer.find(params[:id])
  end

  def set_question
    @question = @mashup_answer.question
  end

  def mashup_params
    params.require(:mashup_answer).permit(:album_id, :song_id, :instrument, :guest)
  end
end