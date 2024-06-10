# == Schema Information
#
# Table name: attempts
#
#  id         :uuid             not null, primary key
#  slug       :string
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

  include MashupScores
  include Sluggable
  friendly_slug_scope to_slug: :title

  # associations
  belongs_to :user
  belongs_to :quiz
  has_many :responses, dependent: :destroy
  has_many :questions, through: :responses, dependent: :destroy

  # validations
  validate :single_attempt_per_quiz

  # instance methods

  def title
    "#{user.username} #{quiz.title}"
  end

  def total_questions
    questions.size
  end

  def correct_attempt_questions
    correct_questions_count = responses.select { |response| response.predicted_correctly?}.size
  end

  def questions_with_correct_answers
    correct_questions_count = questions.select { |question| question.choices.where(correct: true).exists? }.size
  end

  def score
    score = 0

    responses.includes([:question, :choice]).each do |response|
      if response.choice&.correct
        score += response.question.points
      end
    end

    (score + piano_mashup_score + guitar_mashup_score + mixup_mashup_score).to_i
  end

  def total_possible_points
    quiz.questions.sum(:points)
  end

  def position
    attempt_scores = quiz.attempts.map(&:score).compact.sort.reverse
    attempt_scores.index(score)&.+(1)
  end

  private

  def single_attempt_per_quiz
    if Attempt.exists?(user_id: user_id, quiz_id: quiz_id)
      errors.add(:base, "You can only attempt this quiz once")
    end
  end

  def mashup_max_score(ans)
    max_points = 0
    case ans&.downcase
    when 'no mashup'
      max_points = 3
    when 'mashup (2 songs) '
      max_points = 1.5
    when 'mashup (3 songs)'
      max_points = 1
    when 'mashup (4+ songs)'
      max_points = 0.75
    else
      max_points = 0
    end
  end
end
