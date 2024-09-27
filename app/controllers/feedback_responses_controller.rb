class FeedbackResponsesController < ApplicationController
  before_action :set_feedback

  def create
    @feedback_response = @feedback.feedback_responses.new(feedback_response_params)
    @feedback_response.user_id = current_user.id

    respond_to do |format|
      if @feedback_response.save
        format.html { redirect_to feedback_path(@feedback) }
      else
        format.html { render 'feedbacks/show', status: :unprocessable_entity }
      end
    end
  end

  private

  def set_feedback
    @feedback = Feedback.find(params[:feedback_id])
  end

  def feedback_response_params
    params.require(:feedback_response).permit(:message)
  end
end