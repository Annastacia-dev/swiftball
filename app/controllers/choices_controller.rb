class ChoicesController < ApplicationController
  before_action :set_choice, only: %i[ show edit update destroy correct incorrect ]
  before_action :find_question, only: %i[new create]
  before_action :set_quiz, only: %i[new create]
  before_action :authenticate_admin!, only: %i[new edit create update destroy]


  # GET /choices or /choices.json
  def index
    @choices = Choice.all
  end

  # GET /choices/1 or /choices/1.json
  def show
  end

  # GET /choices/new
  def new
    @choice = @question.choices.new
  end

  # GET /choices/1/edit
  def edit
  end

  # POST /choices or /choices.json
  def create
    @choice = @question.choices.new(choice_params)

    respond_to do |format|
      if @choice.save
        if params[:commit] == "Create Choice & Add Another"
          format.html { redirect_to new_quiz_question_choice_path(@question.quiz, @question), notice: "Choice was successfully created." }
        else
          format.html { redirect_to quiz_path(@question.quiz), notice: "Choice was successfully created." }
        end
        format.json { render :show, status: :created, location: @choice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /choices/1 or /choices/1.json
  def update
    path = quiz_question_path(@choice.question.quiz, @choice.question)
    respond_to do |format|
      if @choice.update(choice_params)
        format.html { redirect_to path, notice: "Choice was successfully updated." }
        format.json { render :show, status: :ok, location: @choice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @choice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /choices/1 or /choices/1.json
  def destroy
    @choice.destroy!

    respond_to do |format|
      format.html { redirect_to quiz_question_choices_path(@choice.question.quiz, @choice.question), notice: "Choice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Custom

  def correct
    @question = @choice.question

    if (@question.quiz.tour.status != 'live' && @question.quiz.tour.status != 'closed')
      respond_to do |format|
        format.html { redirect_to request.referrer, alert: 'Please Close this quiz before selecting correct answer' }
      end
    else
      @question.choices.where(correct: true).update(correct: false)

      respond_to do |format|
        if @choice.update(correct: true)
          format.html { redirect_to request.referrer, notice: "Choice was marked correct." }
        else
          format.html { redirect_to request.referrer, alert: "Something went wrong." }
        end
      end
    end
  end

  def incorrect
    @question = @choice.question

    if (@question.quiz.tour.status != 'live' && @question.quiz.tour.status != 'closed')
      respond_to do |format|
        format.html { redirect_to request.referrer, alert: 'Please Close this quiz before marking choices' }
      end
    else
      @question.choices.where(correct: true).update(correct: false)

      respond_to do |format|
        if @choice.update(correct: false)
          format.html { redirect_to request.referrer, notice: "Choice was marked incorrect." }
        else
          format.html { redirect_to request.referrer, alert: "Something went wrong." }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_question
      @question = Question.find(params[:question_id])
    end

    def set_quiz
      @quiz = @question.quiz
    end

    def set_choice
      @choice = Choice.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def choice_params
      params.require(:choice).permit(:question_id, :content, :correct, :image, :new_item, :position)
    end
end
