class MashupAnswersController < ApplicationController

  before_action :find_response

  def index
    @mashup_answers = @response.mashup_answers
    respond_to do |format|
      format.html { render :index }
      format.json {render json: @mashup_answers }
    end
  end


  private

  def find_response
    @response = Response.find(params[:response_id])
  end
end