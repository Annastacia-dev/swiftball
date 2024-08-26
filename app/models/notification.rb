# == Schema Information
#
# Table name: notifications
#
#  id         :uuid             not null, primary key
#  email      :boolean          default(FALSE)
#  in_app     :boolean          default(FALSE)
#  link       :string
#  message    :text
#  push       :boolean          default(FALSE)
#  status     :integer          default("unread")
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid
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
  belongs_to :user, optional: true

  # validations
  validates :subject, presence: true
  validates :message, presence: true

  # enums
  enum status: {
    unread: 0,
    read: 1
  }

  def self.status_options
    statuses.map { |k, _v| [k.humanize, k] }
  end
end
