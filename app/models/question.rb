# == Schema Information
#
# Table name: questions
#
#  id                     :uuid             not null, primary key
#  choices_count          :integer          default(0)
#  content                :text
#  era                    :integer          default("lover")
#  guitar_mashup          :boolean          default(FALSE)
#  include_album_and_song :boolean          default(FALSE)
#  piano_mashup           :boolean          default(FALSE)
#  points                 :integer
#  position               :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  quiz_id                :uuid             not null
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
  has_many :choices, dependent: :destroy, counter_cache: :choices_count
  has_many :mashup_answers, dependent: :destroy

  # validations
  validates :content, presence: true, uniqueness: { scope: :quiz_id }
  validates :position, presence: true, uniqueness: { scope: :quiz_id }
  validates :points, presence: true
  validates :era, presence: true

  # callbacks
  before_validation :set_position

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

  def include_mashup?
    piano_mashup || guitar_mashup
  end

  private

  def set_position
    if position.nil?
      max_position = quiz.questions.maximum(:position) || 0
      self.position = max_position + 1
    end
  end
end
