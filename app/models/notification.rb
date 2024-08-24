# == Schema Information
#
# Table name: notifications
#
#  id         :uuid             not null, primary key
#  email_only :boolean          default(FALSE)
#  link       :string
#  message    :text
#  push_only  :boolean          default(FALSE)
#  status     :integer          default(0)
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :user

  # validations
  validates :subject, presence: true
  validates :message, presence: true

  # enums
  enum status: {
    unread: 0,
    read: 1
  }
end
