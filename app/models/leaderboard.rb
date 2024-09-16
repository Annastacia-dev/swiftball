# == Schema Information
#
# Table name: leaderboards
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :uuid             not null
#
# Indexes
#
#  index_leaderboards_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#
class Leaderboard < ApplicationRecord

  #associations
   belongs_to :creator, class_name: 'User'
end
