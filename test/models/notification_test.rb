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
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
