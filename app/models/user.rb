# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  country                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  terms_and_conditions   :boolean
#  timezone               :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_paper_trail
  # Include default devise modules. Others available are:
  #:lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # associations
  has_many :attempts, dependent: :destroy

  # validations
  validates :terms_and_conditions, acceptance: true
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :timezone, presence: true
  validates :country, presence: true

  # scopes
  scope :has_attempted_quiz, ->(quiz_id) {
    joins(:attempts).where(attempts: { quiz_id: quiz_id }).distinct
  }

  # enums
  enum role: {
    user: 0,
    admin: 1
  }

  # instance methods

  def has_attempted_quiz?(quiz_id)
    attempts.exists?(quiz_id: quiz_id)
  end

  def current_streak
    tours = Tour.where.not(base: true)
    quizzes = tours.each { |tour| tour.quiz}
    
    current_streak = 0
    attempts.each_with_index do |attempt, index|
      if index == 0 || ((attempt.created_at - attempts[index - 1].created_at) <= 1.day && quizzes.include?(attempt.quiz_id))
        current_streak += 1
      else
        break
      end
    end
    current_streak
  end

  def max_streak
    tours = Tour.where.not(base: true)
    quizzes = tours.map { |tour| tour.quiz.id }
    
    max_streak = 0
    current_streak = 0
    attempts.each_with_index do |attempt, index|
      if index == 0 || ((attempt.created_at - attempts[index - 1].created_at) <= 1.day && quizzes.include?(attempt.quiz_id))
        current_streak += 1
        max_streak = [max_streak, current_streak].max
      else
        current_streak = 0
      end
    end
    max_streak
  end
end
