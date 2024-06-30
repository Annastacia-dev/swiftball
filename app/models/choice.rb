# == Schema Information
#
# Table name: choices
#
#  id              :uuid             not null, primary key
#  content         :string
#  correct         :boolean          default(FALSE)
#  new_item        :boolean          default(FALSE)
#  position        :integer
#  responses_count :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  question_id     :uuid             not null
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
  belongs_to :question, counter_cache: true, dependent: :destroy
  has_many :responses, counter_cache: :responses_count, dependent: :destroy

  # validations
  validates :content, presence: true, uniqueness: { scope: :question_id }
  validates :position, presence: true, uniqueness: { scope: :question_id }
  validate :tour_is_closed_before_marking_correct
  validate :only_one_correct_answer_per_question, if: :correct_changed?

  # callbacks
  before_validation :set_position

  # instance methods
  def percentage_of_total_responses
    total_responses = question.responses.count
    choice_responses = responses.count
    return 0 if total_responses.zero?

    ((choice_responses.to_f / total_responses) * 100).round
  end

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
    if correct_answer && correct === true
      errors.add(:base, "A correct answer already exists mark it as false then choose another one")
    end
  end
end
