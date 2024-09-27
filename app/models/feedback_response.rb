# == Schema Information
#
# Table name: feedback_responses
#
#  id          :uuid             not null, primary key
#  message     :text
#  status      :integer          default("unread")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feedback_id :uuid             not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_feedback_responses_on_feedback_id  (feedback_id)
#  index_feedback_responses_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (feedback_id => feedbacks.id)
#  fk_rails_...  (user_id => users.id)
#
class FeedbackResponse < ApplicationRecord

  # associations
  belongs_to :feedback
  belongs_to :user

   # enums
   enum status:{
    unread: 0,
    read: 1
  }

  # validations
  validates :message, presence: true, restricted_keywords: true, obscenity: true
end
