# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
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
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  has_paper_trail

  include StreakScores

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # associations
  has_many :attempts, dependent: :destroy
  has_many :push_subscriptions

  # validations
  validates :email, presence: true, email: true
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
end
