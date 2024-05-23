# == Schema Information
#
# Table name: choices
#
#  id          :uuid             not null, primary key
#  content     :string
#  correct     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :uuid             not null
#
# Indexes
#
#  index_choices_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
class Choice < ApplicationRecord
  has_paper_trail

  has_one_attached :image

  # association
  belongs_to :question

  # validations
  validates :content, presence: true, uniqueness: { scope: :question_id }
  validate :tour_is_closed_before_marking_correct
  validate :only_one_correct_answer_per_question

  private

  def tour_is_closed_before_marking_correct
    if correct == true && question.quiz.tour.status != 'closed'
      errors.add(:base, "Please close the quiz before choosing correct answers")
    end
  end

  def only_one_correct_answer_per_question
    correct_answer = question.choices.find_by(correct: true)
    if correct_answer
      errors.add(:base, "A correct answer already exists mark it as false then choose another one")
    end
  end
end
