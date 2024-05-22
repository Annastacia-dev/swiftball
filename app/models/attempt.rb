# == Schema Information
#
# Table name: attempts
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_attempts_on_quiz_id  (quiz_id)
#  index_attempts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#  fk_rails_...  (user_id => users.id)
#
class Attempt < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :user
  belongs_to :quiz
  has_many :responses, dependent: :destroy
  has_many :questions, through: :responses, dependent: :destroy

  # validations
  validate :single_attempt_per_quiz

  # instance methods

  def total_questions
    questions.size
  end

  def score
    score = 0

    responses.each do |response|
      if response.predicted_correctly?
        score += response.question.points
      end
    end

    score
  end

  private

  def single_attempt_per_quiz
    if Attempt.exists?(user_id: user_id, quiz_id: quiz_id)
      errors.add(:base, "You can only attempt this quiz once")
    end
  end
end
