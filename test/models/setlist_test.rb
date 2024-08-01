# == Schema Information
#
# Table name: setlists
#
#  id         :uuid             not null, primary key
#  league     :string
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tour_id    :uuid
#
# Indexes
#
#  index_setlists_on_tour_id  (tour_id)
#
# Foreign Keys
#
#  fk_rails_...  (tour_id => tours.id)
#
require "test_helper"

class SetlistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
