class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ terms_and_conditions privacy_policy disclaimer]

  def stats
    @chart_type = params[:chart_type] || 'bar_chart'
    @user = current_user.admin? ? User.friendly.find(params[:id]) : current_user
    @attempts = @user.attempts
    @current_streak = @user.current_streak
    @max_streak = @user.max_streak
    attempts_count = @user.attempts.size

    attempts_for_average = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }

    @average_score = attempts_for_average.size.zero? ? 0 : attempts_for_average.map(&:score).sum.to_i / attempts_for_average.size
    @lifetime_points = attempts_for_average.map(&:score).sum
    @best_score = attempts_for_average.map(&:score).max || 0

    @responses = @attempts.includes([:quiz, :responses]).reject { |attempt| attempt.quiz.tour.status == 'open' }.map(&:responses).flatten.uniq

    correct_responses = @responses.select { |response| response&.choice&.correct }
    questions = correct_responses.map(&:question).flatten.sort_by { |question| question.era }
    all_question_accuracy = questions.group_by { |qn| qn.content }.transform_values(&:count)
    total_responses = @user.attempts.map(&:responses).size
    @all_questions = Question.where.not(include_album_and_song: true).order(:era).order(:position).pluck(:content, :position).to_h


    @questions_predictions_data = @all_questions.map do |question_content, position|
      correct_count = all_question_accuracy[question_content] || 0
      percentage = ((correct_count.to_f / total_responses.to_f) * 100).round(2)
      [question_content, "#{percentage}%"]
    end

    custom_era_order = Question.eras.keys

    @questions_predictions_by_era_data = Question.where.not(include_album_and_song: true).group_by(&:era).sort_by { |era, _| custom_era_order.index(era) }.map do |era, era_questions|
      era_questions_accuracy = era_questions.map(&:content).map do |content|
        all_question_accuracy[content] || 0
      end.first

      total_era_questions = era_questions.group_by(&:content).length * total_responses

      era_accuracy_percentage = ((era_questions_accuracy.to_f / total_era_questions.to_f) * 100).round(2)

      [era.humanize.titleize, "#{era_accuracy_percentage}%"]
    end.to_h
  end

  def leaderboard
    @tours = Tour.where.not(status: :pending).where.not(base: true).order(number: :desc)
    @users = User.where.not(role: :admin)
    if params[:tour]
      @tour = Tour.friendly.find(params[:tour])
    else
      @tour = @tours.first
    end

    current_index = @tours.index(@tour)
    @next_tour = @tours[current_index - 1] if current_index && current_index > 0
    @previous_tour = @tours[current_index + 1] if current_index && current_index < @tours.size - 1

    @attempts = Attempt.where(quiz_id: @tour.quiz.id).sort_by { |attempt| [-attempt.score, attempt.created_at] }
  end
end