# == Schema Information
#
# Table name: leaderboard_users
#
#  id             :uuid             not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  leaderboard_id :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_leaderboard_users_on_leaderboard_id  (leaderboard_id)
#  index_leaderboard_users_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (leaderboard_id => leaderboards.id)
#  fk_rails_...  (user_id => users.id)
#
class LeaderboardUser < ApplicationRecord
  belongs_to :user
  belongs_to :leaderboard
end
