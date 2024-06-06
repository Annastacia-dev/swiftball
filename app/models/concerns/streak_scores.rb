# Determine user's streak

module StreakScores

  def current_streak
    variables
    result = []

    @quizzes.each do |quiz|
      attempt = @attempts.find_by(quiz_id: quiz.id)
      if attempt
        result << [quiz.created_at, attempt.created_at]
      else
        result << [quiz.created_at, nil]
      end
    end

    result.sort_by! { |quiz_date, attempt_date| quiz_date }.reverse!

    streak = 0

    result.each do |pair|
      break if pair[1].nil?
      streak += 1
    end

    streak
  end

  def max_streak
    variables

    result = []

    @quizzes.each do |quiz|
      attempt = @attempts.find_by(quiz_id: quiz.id)
      if attempt
        result << [quiz.created_at, attempt.created_at]
      else
        result << [quiz.created_at, nil]
      end
    end

    result.sort_by! { |quiz_date, attempt_date| quiz_date }.reverse!

    current_streak = 0
    longest_streak = 0

    result.each do |item|
      if item[1].nil?
        current_streak = 0
      else
        current_streak += 1
        longest_streak = current_streak if current_streak > longest_streak
      end
    end

    longest_streak
  end

  private

  def variables
    @tours = Tour.where.not(base: true, status: [:pending]).includes(:quiz)
    @quizzes = @tours.map { |tour| tour.quiz}

    @attempts = self.attempts.order(created_at: :desc)
  end
end