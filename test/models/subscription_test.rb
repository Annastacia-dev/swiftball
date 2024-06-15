# == Schema Information
#
# Table name: subscriptions
#
#  id         :bigint           not null, primary key
#  endpoint   :string           not null
#  keys       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_endpoint  (endpoint) UNIQUE
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
