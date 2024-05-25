class ResponsesController < ApplicationController

  before_action :find_response, only: %i[show]

  def show
    respond_to do |format|
      format.html { render :show }
      format.json {render json: @response }
    end
  end


  private

  def find_response
    @response = Response.find(params[:id])
  end
end