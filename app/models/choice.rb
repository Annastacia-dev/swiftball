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
  validates :content, presence: true, uniqueness: true
end
