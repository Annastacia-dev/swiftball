# == Schema Information
#
# Table name: responses
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  attempt_id  :uuid             not null
#  choice_id   :uuid
#  question_id :uuid             not null
#
# Indexes
#
#  index_responses_on_attempt_id   (attempt_id)
#  index_responses_on_choice_id    (choice_id)
#  index_responses_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (attempt_id => attempts.id)
#  fk_rails_...  (choice_id => choices.id)
#  fk_rails_...  (question_id => questions.id)
#
class Response < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :question
  belongs_to :choice, optional: :true, counter_cache: :true
  belongs_to :attempt
  has_many :mashup_answers, dependent: :destroy


  # instance methods

  def predicted_correctly?
    if question.choices.size.positive?
      question.choices.find_by(correct: true) == choice
    end
  end
end
