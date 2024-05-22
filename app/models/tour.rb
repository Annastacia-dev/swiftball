# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
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
  validate :one_quiz

  # enums
  enum status: {
    pending: 0,
    open: 1,
    closed: 2
  }

  # callbacks
  before_save :downcase_title
  after_create :create_quiz

  private

  def downcase_title
    self.title = title.downcase
  end

  def create_quiz
    quiz = Quiz.order(created_at: :desc).first
    if quiz
      dupe = quiz.dup
      dupe.update(tour_id: self.id)
      dupe << quiz.questions
    else
      create_new_quiz
    end
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
