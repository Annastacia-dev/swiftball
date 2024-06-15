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
class Subscription < ApplicationRecord
  serialize :keys, Hash
end

