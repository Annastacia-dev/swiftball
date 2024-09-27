# == Schema Information
#
# Table name: feedbacks
#
#  id         :uuid             not null, primary key
#  message    :text
#  status     :integer          default("unread")
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_feedbacks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Feedback < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :user
  has_many :feedback_responses, dependent: :destroy

  # enums
  enum status:{
    unread: 0,
    read: 1
  }

  # validations
  validates :subject, presence: true, restricted_keywords: true, obscenity: true
  validates :message, presence: true, restricted_keywords: true, obscenity: true
end
