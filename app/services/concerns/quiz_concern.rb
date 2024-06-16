#shared methods for quiz

module QuizConcern
  extend ActiveSupport::Concern

  attr_reader :quiz_id, :quiz, :all_users, :users_without_attempt

  def find_quiz
    return if quiz_id.blank?


    puts 'Finding quiz...'
    @quiz = Quiz.find(quiz_id)

    if quiz.present?
      logger.info("Found #{quiz.title}")
      return true
    end

    log_error "Could not find quiz with id: #{quiz_id}"
    false
  end

  def find_users_without_attempt
    return if quiz.blank?

    puts "Finding users who haven't taken the quiz"

    @all_users = User.all
    @users_without_attempt =  User.all.select do |user|
      !user.attempts.find_by(quiz_id: quiz.id)
    end

    if users_without_attempt.present?
      logger.info("Found #{users_without_attempt.size} / #{all_users.size} who have not attempted the quiz")
      return true
    end

    logger.info('All users have taken the quiz')
    false
  end
end