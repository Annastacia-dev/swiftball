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
  has_many :quizzes
  has_many :attempts

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
end
