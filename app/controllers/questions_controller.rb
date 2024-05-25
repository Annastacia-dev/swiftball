class QuestionsController < ApplicationController
  before_action :find_quiz
  before_action :set_question, only: %i[ show edit update destroy pick_surprise_song ]

  # GET /questions or /questions.json
  def index
    @questions = Question.all
    @questions_by_era = Question.all.order(:created_at).group_by(&:era)
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = @quiz.questions.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = @quiz.questions.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to quiz_questions_path(@quiz), notice: "Question was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to quiz_questions_path(@quiz), notice: "Question was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy!

    respond_to do |format|
      format.html { redirect_to quiz_questions_path(@quiz), notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pick_surprise_song
    guitar = 'Will there be a Guitar Surprise Song Mashup?'
    piano = 'Will there be a Piano Surprise Song Mashup?'

    if @question.content.downcase == 'pick piano acoustic set album and song'
      mashup_qn = @quiz.questions.find_by(content: piano)
      @mashup_ans = mashup_qn.choices.find_by(correct: true)
      respond_to do |format|
        if @mashup_ans
          format.html { render :pick_surprise_song }
        else
          format.html { redirect_to quiz_question_path(@quiz,mashup_qn), alert: "Please pick an answer for the mashup question first" }
        end
      end
    elsif @question.content.downcase == 'pick guitar acoustic set album and song'
      mashup_qn = @quiz.questions.find_by(content: guitar)
      @mashup_ans = mashup_qn.choices.find_by(correct: true)
      respond_to do |format|
        if @mashup_ans
          format.html { render :pick_surprise_song }
        else
          format.html { redirect_to quiz_question_path(@quiz,mashup_qn), alert: "Please pick an answer for the mashup question first" }
        end
      end
    end
  end

  def surprise_song_answer
    (0..3).each do |i|
      albums = params["albums_#{i}"]
      songs = params["songs_#{i}"]

      if albums.present?
        albums.each do |question_id, album_id|
          song_id = songs[question_id]
          MashupAnswer.create!(
            question_id: question_id,
            album_id: album_id,
            song_id: song_id,
            correct: true
          )
        end
      end
    end

    redirect_to quiz_path(@quiz), notice: "Surprise songs added"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_quiz
      @quiz = Quiz.friendly.find(params[:quiz_id])
    end
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:quiz_id, :era, :points, :content, :include_mashup, :include_album_and_song)
    end
end
