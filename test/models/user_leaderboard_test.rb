# == Schema Information
#
# Table name: user_leaderboards
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :uuid             not null
#
# Indexes
#
#  index_user_leaderboards_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
require "test_helper"

class UserLeaderboardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
