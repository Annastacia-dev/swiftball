class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[show destroy ]

  # GET /feedbacks or /feedbacks.json
  def index
    @feedbacks = Feedback.all.order(created_at: :desc)
    @user_feedbacks = Feedback.where(user: current_user)
    @feedback = current_user.feedbacks.new
  end

  # GET /feedbacks/1 or /feedbacks/1.json
  def show
    @feedback_response = @feedback.feedback_responses.new

    respond_to do |format|
      if @feedback.status == 'read'
        format.html { render :show }
      else
        if @feedback.update(status: 'read')
          @feedback.feedback_responses.where(status: 'unread').update(status: 'read')
          format.html { render :show }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /feedbacks/new
  def new
    @feedback = current_user.feedbacks.new
  end

  # POST /feedbacks or /feedbacks.json
  def create
    @feedback = current_user.feedbacks.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to feedbacks_path, notice: "Feedback was successfully submitted." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1 or /feedbacks/1.json
  def destroy
    @feedback.destroy!

    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: "Feedback was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def feedback_params
      params.require(:feedback).permit(:subject, :message)
    end
end
