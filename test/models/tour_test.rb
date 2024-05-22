# == Schema Information
#
# Table name: tours
#
#  id         :uuid             not null, primary key
#  base       :boolean          default(FALSE)
#  date       :date
#  number     :integer
#  slug       :string
#  start_time :time
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
