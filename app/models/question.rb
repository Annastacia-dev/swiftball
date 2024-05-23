# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  content       :text
#  era           :integer          default("lover")
#  include_album :boolean          default(FALSE)
#  include_song  :boolean          default(TRUE)
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
  validates :content, presence: true, uniqueness: { scope: :quiz_id }
  validates :points, presence: true
  validates :era, presence: true

  # enums
  enum era: {
    lover: 0,
    fearless: 1,
    red: 2,
    speak_now: 3,
    reputation: 4,
    folkmore: 5,
    '1989': 6,
    the_tortured_poets_department: 7,
    acoustic_set: 8,
    midnights: 9,
    extra: 10
  }

  def self.eras_options
    eras.map { |k, _v| [k.humanize, k] }
  end
end
