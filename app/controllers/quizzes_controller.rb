class QuizzesController < ApplicationController

  include OrderQuestions

  before_action :set_quiz
  before_action :order_questions, only: %i[show take progress results]
  before_action :authenticate_admin!, only: %i[show edit destroy open close]
  before_action :authenticate_not_admin!, only: %i[take]
  before_action :check_attempt_exists, only: %i[take]
  before_action :check_tour_open, only: %i[take]
  before_action :set_tour, except: %i[index]

  # GET /quizzes/1/edit
  def edit
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz&.questions.each  { |qn| qn.choices.each { |choice| choice.delete }}
    @quiz&.questions.each  { |qn| qn.mashup_answers.each { |answer| answer.delete }}
    @quiz&.questions.each { |qn| qn.delete }
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

        format.html { redirect_to attempt_path(attempt), notice: "Your answers have been submitted!" }
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
          create_notification
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
          update_attempts_final_position
          update_attempts_final_score
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

  def send_notification

    notification = Notification.new(
      subject: "Welcome To The Final Show - #{@quiz.title} Quiz is open!",
      message: "#{@quiz.title} is open!<br/><br/>Make your predictions",
      link: take_quiz_url(@quiz),
      link_text: 'Predict',
      push: true
    )

    respond_to do |format|
      if notification.save
        format.html { redirect_to tours_path, notice: 'Notifications send' }
        send_notification_via_worker(notification)
      else
        puts "Something went wrong"
        format.html { redirect_to tours_path, alert: 'Something went wrong' }
      end
    end
  end

  def update_positions
    update_attempts_final_position

    respond_to do |format|
      format.html { redirect_to tour_path(@quiz.tour), notice: 'Successfully updated final positions for all attempts' }
    end
  end

  def update_scores
    update_attempts_final_score

    respond_to do |format|
      format.html { redirect_to tour_path(@quiz.tour), notice: 'Successfully updated final scores for all attempts' }
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

    def check_attempt_exists
      attempt = current_user.attempts.find_by(quiz_id: @quiz.id)
      respond_to do |format|
        if attempt.present?
          format.html { redirect_to attempt_path(attempt), notice: 'You have already submitted your predictions.' }
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

    def create_notification
      notification = Notification.new(
        subject: "Welcome To The Final Show - #{@quiz.title} Quiz is open!",
        message: "#{@quiz.title} is open!<br/><br/>Make your predictions",
        link: take_quiz_url(@quiz),
        link_text: 'Predict',
        email: true,
        push: true
      )

      if notification.save
        send_notification_via_worker(notification)
      else
        puts "Something went wrong"
      end
    end

    def send_notification_via_worker(notification)
      NotificationWorker.perform_async(notification.id)
    end

    def update_attempts_final_position
      @quiz.attempts.sort_by { |attempt| [-attempt.score, attempt.created_at] }.each_with_index do |attempt, index|
        attempt.update!(final_position: index + 1 )
      end
    end

    def update_attempts_final_score
      @quiz.attempts.each do |attempt|
        attempt.update!(final_score: attempt.score )
      end
    end
end
