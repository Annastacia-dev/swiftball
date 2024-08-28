class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ terms_and_conditions privacy_policy disclaimer]

  def stats
    @chart_type = params[:chart_type] || 'bar_chart'
    @user = current_user.admin? ? User.friendly.find(params[:id]) : current_user
    @attempts = @user.attempts
    @current_streak = @user.current_streak
    @max_streak = @user.max_streak
    attempts_count = @user.attempts.size

    @attempts_stats = @attempts.includes(:responses, quiz: :tour).map { |attempt| [attempt.quiz.tour.title.titleize, attempt.score]}

    attempts_for_average = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }

    @average_score = attempts_for_average.size.zero? ? 0 : attempts_for_average.map(&:score).sum.to_i / attempts_for_average.size
    @lifetime_points = attempts_for_average.map(&:score).sum
    @best_score = attempts_for_average.map(&:score).max || 0

    @responses = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }.map(&:responses).flatten.uniq

    correct_responses = @responses.select { |response| response&.choice&.correct }
    questions = correct_responses.map(&:question).flatten.sort_by { |question| question.era }
    all_question_accuracy = questions.group_by { |qn| qn.content }.transform_values(&:count)
    total_responses = @user.attempts.map(&:responses).size
    @all_questions = Question.joins(quiz: :tour)
                             .where.not(tours: { preapp: true })
                             .where.not(include_album_and_song: true)
                             .order(:era)
                             .order(:position)
                             .pluck(:content, :position)
                             .to_h


    @questions_predictions_data = @all_questions.map do |question_content, position|
      correct_count = all_question_accuracy[question_content] || 0
      percentage = ((correct_count.to_f / total_responses.to_f) * 100).round(2)
      [question_content, "#{percentage}%"]
    end

    custom_era_order = Question.eras.keys

    @questions_predictions_by_era_data = Question.joins(quiz: :tour)
                                                 .where.not(tours: { preapp: true })
                                                 .where.not(include_album_and_song: true)
                                                 .group_by(&:era).sort_by { |era, _| custom_era_order.index(era) }
                                                 .map do |era, era_questions|
      era_questions_accuracy = era_questions.map(&:content).map do |content|
        all_question_accuracy[content] || 0
      end.first

      total_era_questions = era_questions.group_by(&:content).length * total_responses

      era_accuracy_percentage = ((era_questions_accuracy.to_f / total_era_questions.to_f) * 100).round(2)

      [era.humanize.titleize, "#{era_accuracy_percentage}%"]
    end.to_h
  end

  def leaderboard
    @tours = Tour.where.not(status: [:pending, :cancelled]).where.not(base: true).where.not(preapp: true).order(number: :desc)
    @users = User.where.not(role: :admin)
    if params[:tour]
      @tour = Tour.friendly.find(params[:tour])
    else
      @tour = @tours.first
    end

    current_index = @tours.index(@tour)
    @next_tour = @tours[current_index - 1] if current_index && current_index > 0
    @previous_tour = @tours[current_index + 1] if current_index && current_index < @tours.size - 1

    if @tour.status == 'closed'
      @attempts = @tour.quiz.attempts
                          .includes(:responses, :user)
                          .order(:final_position)
                          .paginate(page: params[:page], per_page: 20)
    else
      @attempts = @tour.quiz.attempts
      .includes(:responses, :user)
      .sort_by { |attempt| [-attempt.score, attempt.created_at] }
    end

  end

  def surprise_songs
    tours = Tour.where.not(base: true)
                .where(status: [:closed, :live])
                .order(number: :desc)
    if params[:query]
      @tours = tours.search(params[:query])
    else
      @tours = tours
    end
    @view = params[:view] || 'card_view'
    @albums = Album.includes(:songs).where(status: :active)
    @correct_mashups = MashupAnswer.includes([question: [quiz: :tour]]).where(correct: true)
    records
    @album_song_stats = @correct_mashups.group_by { |mashup| mashup.album_id }.map do |album_id, mashups|
      album = Album.find(album_id)
      album_title = album.abbr.titleize
      count = mashups.size
      [album_title, count, album.created_at]
    end.sort_by { |_, _, created_at| created_at }
  end

  private

  def records
    @correct_mashups = MashupAnswer.includes(question: [quiz: :tour]).where(correct: true)

    # Process song counts
    @song_counts = @correct_mashups.group(:song_id).count
    @most_frequent_song_id, @most_frequent_song_count = @song_counts.max_by { |_song_id, count| count }
    @most_frequent_song = Song.find(@most_frequent_song_id)

    @song_performance_counts = @correct_mashups
      .where(song_id: @most_frequent_song_id)
      .group(:instrument)
      .count

    # Process album counts
    @album_counts = @correct_mashups.group(:album_id).count
    @most_frequent_album_id, @most_frequent_album_count = @album_counts.max_by { |_album_id, count| count }
    @most_frequent_album = Album.find(@most_frequent_album_id)

    @album_performance_counts = @correct_mashups
      .where(album_id: @most_frequent_album_id)
      .group(:instrument)
      .count

    # Find tours with specific conditions
    @tours_for_instruments = {}
    @correct_mashups.each do |mashup|
      next unless mashup.correct

      tour_title = mashup.question.quiz.tour.title
      instrument = mashup.instrument

      if @tours_for_instruments[instrument].nil?
        @tours_for_instruments[instrument] = { count: 0, tours: [] }
      end

      @tours_for_instruments[instrument][:count] += 1
      @tours_for_instruments[instrument][:tours] << tour_title if @tours_for_instruments[instrument][:count] <= 3
    end
  end


end