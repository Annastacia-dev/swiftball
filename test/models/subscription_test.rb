# == Schema Information
#
# Table name: subscriptions
#
#  id         :uuid             not null, primary key
#  auth       :string
#  endpoint   :string
#  p256dh     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
