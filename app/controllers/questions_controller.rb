class QuestionsController < ApplicationController

  include OrderQuestions

  before_action :find_quiz
  before_action :order_questions, only: %i[index]
  before_action :set_question, except: %i[index new create ]
  before_action :authenticate_admin!, only: %i[new edit create update destroy]

  # GET /questions or /questions.json

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = @quiz&.questions.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = @quiz&.questions.new(question_params)

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
    @question.choices.each { |choice| choice.delete }
    @question.delete

    respond_to do |format|
      format.html { redirect_to quiz_questions_path(@quiz), notice: "Question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pick_surprise_song
    guitar = @quiz&.questions.find_by(guitar_mashup: true)
    piano = @quiz&.questions.find_by(piano_mashup: true)

    if @question.content.downcase == 'pick piano acoustic set album and song'
      @mashup_ans = piano&.choices&.find_by(correct: true)&.content&.downcase || 'no mashup'
      respond_to do |format|
        if @mashup_ans
          format.html { render :pick_surprise_song }
        else
          format.html { redirect_to quiz_question_path(@quiz, piano), alert: "Please pick an answer for the mashup question first" }
        end
      end
    elsif @question.content.downcase == 'pick guitar acoustic set album and song'
      @mashup_ans = guitar&.choices&.find_by(correct: true)&.content&.downcase || 'no mashup'
      respond_to do |format|
        if @mashup_ans
          format.html { render :pick_surprise_song }
        else
          format.html { redirect_to quiz_question_path(@quiz,guitar), alert: "Please pick an answer for the mashup question first" }
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
            correct: true,
            instrument: params[:instrument]
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
      params.require(:question).permit(:quiz_id, :era, :points, :content, :piano_mashup, :guitar_mashup, :include_album_and_song)
    end
end
