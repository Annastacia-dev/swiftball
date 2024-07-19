# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
#  base       :boolean          default(FALSE)
#  era_order  :integer          default("new_order")
#  number     :integer
#  preapp     :boolean          default(FALSE)
#  slug       :string
#  start_time :datetime
#  status     :integer          default("pending")
#  timezone   :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class TourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
