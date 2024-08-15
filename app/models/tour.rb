# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
#  base       :boolean          default(FALSE)
#  era_order  :integer          default("new_order")
#  number     :integer
#  preapp     :boolean          default(FALSE)
#  slug       :string
#  start_time :datetime
#  status     :integer          default("pending")
#  timezone   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tour < ApplicationRecord
  has_paper_trail
  has_one_attached :city_image

  include Sluggable
  include Searchable

  friendly_slug_scope to_slug: :title
  searchable against: %i[title number]

  # associations
  has_one :quiz, dependent: :destroy
  has_many :attempts, through: :quiz, dependent: :destroy
  has_many :mashup_answers, through: :quiz, dependent: :destroy
  has_and_belongs_to_many :openers

  # validations
  validates :title, presence: true, uniqueness: true
  validates :number, presence: { unless: :is_cancelled?}, uniqueness: { unless: :number_is_nil?}
  validates :start_time, presence: true, uniqueness: true
  validates :timezone, presence: true
  validate :one_quiz, on: :create

  # enums
  enum status: {
    pending: 0,
    open: 1,
    live: 2,
    closed: 3,
    cancelled: 4
  }

  enum era_order: {
    new_order: 0,
    old_order: 1
  }

  # callbacks
  before_validation :downcase_title
  before_validation :set_timezone
  after_create :create_quiz, if: :not_preapp?
  after_update :update_quiz_slug, if: :saved_change_to_title?

  def quiz_live_time
    self.start_time + 1.hour + 15.minutes
  end

  def quiz_close_time
    self.start_time + 5.hour
  end

  def self.era_order_options
    era_orders.map { |k, _v| [k.humanize, k] }
  end

  def self.status_options
    statuses.map { |k, _v| [k.humanize, k] }
  end

  private

  def is_cancelled?
    self.status == 'cancelled'
  end

  def number_is_nil?
    self.number.nil?
  end

  def not_preapp?
    !preapp
  end

  def downcase_title
    self.title = title.downcase
  end

  def set_timezone
    self.timezone = "Africa/Nairobi"
  end

  def create_quiz
    tour = Tour.where.not(id: self.id).order(number: :desc).first
    quiz = tour&.quiz
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
    original_quiz&.questions.each do |original_question|
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

  def should_generate_new_friendly_id?
    title_changed?
  end

  def update_quiz_slug
    quiz.regenerate_slug if quiz.present?
  end
end
