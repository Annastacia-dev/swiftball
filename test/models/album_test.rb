# == Schema Information
#
# Table name: albums
#
#  id         :uuid             not null, primary key
#  abbr       :string
#  slug       :string
#  status     :integer          default("active")
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class AlbumTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
