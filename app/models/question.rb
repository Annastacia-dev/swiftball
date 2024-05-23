# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  content       :text
#  era           :integer          default("lover")
#  include_album :boolean          default(FALSE)
#  points        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quiz_id       :uuid             not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#
class Question < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :quiz
  has_many :choices, dependent: :destroy

  # validations
  validates :content, presence: true, uniqueness: true
  validates :points, presence: true
  validates :era, presence: true

  # enums
  enum era: {
    lover: 0,
    fearless: 1,
    red: 2,
    speak_now: 3,
    folkmore: 4,
    '1989': 5,
    the_tortured_poets_department: 6,
    acoustic_set: 7,
    midnights: 8,
    extra: 9
  }

  def self.eras_options
    eras.map { |k, _v| [k.humanize, k] }
  end
end
