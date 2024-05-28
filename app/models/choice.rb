# == Schema Information
#
# Table name: choices
#
#  id          :uuid             not null, primary key
#  content     :string
#  correct     :boolean          default(FALSE)
#  new_item    :boolean          default(FALSE)
#  position    :integer
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
  validates :position, presence: true, uniqueness: { scope: :question_id }
  validate :tour_is_closed_before_marking_correct
  validate :only_one_correct_answer_per_question, if: :correct_changed?

  # callbacks
  before_validation :set_position

  private

  def set_position
    if position.nil?
      max_position = question.choices.maximum(:position) || 0
      new_item = question.choices.find_by(new_item: true)
      new_item_position = new_item&.position

      if new_item_position
        self.position = new_item_position
        new_item.update(position: new_item_position + 1)
      else
        if max_position
          self.position = max_position + 1
        end
      end
    end
  end

  def tour_is_closed_before_marking_correct
    if correct == true && ( question.quiz.tour.status != 'closed' && question.quiz.tour.status != 'live' )
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
