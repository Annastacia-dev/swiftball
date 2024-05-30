class QuizzesController < ApplicationController

  before_action :set_quiz, only: %i[ show edit destroy take live open close submit results progress]
  before_action :authenticate_admin!, only: %i[show edit destroy open close]
  before_action :check_tour_open, only: %i[take]
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

  def submit

    if @quiz.tour.status == 'open'
      selected_options = params[:selected_options]

      return if selected_options.blank?

      attempt =  current_user.attempts.new(quiz: @quiz)

      respond_to do |format|
        if attempt.save
          selected_options.each do |question_id, choice_id|
            attempt.responses.create(
              question_id: question_id,
              choice_id: choice_id
            )
          end

        update_mashup_answers(attempt)

        format.html { redirect_to tours_path, notice: "Your answers have been submitted!" }
        else
          format.html { render :take, status: :unprocessable_entity }
        end
      end
    else
      format.html { redirect_to root_path, alert: 'Sorry you missed this one, Quiz is closed' }
    end
  end

  def update_mashup_answers(attempt)
    (0..3).each do |i|
      albums = params["albums_#{i}"]
      songs = params["songs_#{i}"]

      if albums.present?
        albums.each do |question_id, album_id|
          song_id = songs[question_id]

          response = attempt.responses.create(
            question_id: question_id
          )

          response.mashup_answers.create(
            question_id: question_id,
            album_id: album_id,
            song_id: song_id
          )
        end
      end
    end
  end

  def live
    if @tour.status != 'live'
      respond_to do |format|
        if @tour.update(status: :live)
          format.html { redirect_to tours_path, notice: 'Show is now live & quiz is close' }
        else
          format.html { redirect_to tours_path, notice: 'Something went wrong, try again' }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to tours_path, notice: 'Show is already live' }
      end
    end
  end

  def open
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

  def close
    if @tour.status != 'closed'
      respond_to do |format|
        if @tour.update(status: :closed)
          format.html { redirect_to tours_path, notice: 'Quiz is now closed' }
        else
          format.html { redirect_to tours_path, alert: "#{@tour.errors.join(',')}", status: :unprocessable_entity }
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

    def check_tour_open
      respond_to do |format|
        if @quiz.tour.status == 'closed' || @quiz.tour.status == 'live'
          format.html { redirect_to root_path, alert: 'Sorry you missed this one, Quiz is closed' }
        elsif  @quiz.tour.status == 'pending'
          format.html { redirect_to root_path, alert: 'Hey early bird, Quiz is not yet open' }
        else
         format.html  { render :take }
        end
      end
    end

    def manually_merge_hashes(*hashes)
      merged_hash = {}
      hashes.each do |hash|
        next if hash.nil?
        hash.each do |key, value|
          merged_hash[key] = value
        end
      end
      merged_hash
    end
end
