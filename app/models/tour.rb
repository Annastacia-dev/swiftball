# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
#  base       :boolean          default(FALSE)
#  date       :date
#  number     :integer
#  slug       :string
#  start_time :time
#  status     :integer          default("pending")
#  timezone   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tour < ApplicationRecord
  has_paper_trail

  include Sluggable
  friendly_slug_scope to_slug: :title

  # associations
  has_one :quiz, dependent: :destroy

  # validations
  validates :title, presence: true, uniqueness: true
  validates :number, presence: true, uniqueness: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :timezone, presence: true
  validate :one_quiz, on: :create

  # enums
  enum status: {
    pending: 0,
    open: 1,
    live: 2,
    closed: 3
  }

  # callbacks
  before_save :downcase_title
  after_create :create_quiz

  def quiz_live_time
    self.start_time + 1.hour
  end

  def quiz_close_time
    self.start_time + 5.hour
  end

  private

  def downcase_title
    self.title = title.downcase
  end

  def create_quiz
    quiz = Quiz.order(created_at: :desc).first
    if quiz
      duplicate_quiz(quiz)
    else
      create_new_quiz
    end
  end

  def duplicate_quiz(original_quiz)
    dupe = original_quiz.dup
    dupe.tour_id = self.id
    dupe.save!
    original_quiz.questions.each do |original_question|
      new_question = original_question.dup
      new_question.quiz_id = dupe.id
      new_question.save!

      original_question.choices.each do |original_choice|
        new_choice = original_choice.dup
        new_choice.question_id = new_question.id
        new_choice.correct = false
        new_choice.save!

        if original_choice.image.attached?
          new_choice.image.attach(original_choice.image.blob)
        end
      end
    end
    dupe
  end

  def create_new_quiz
    Quiz.create!(tour_id: self.id)
  end

  def one_quiz
    if self.quiz
      errors.add(:base, "This tour alread has a quiz")
    end
  end
end
