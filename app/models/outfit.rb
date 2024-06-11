# == Schema Information
#
# Table name: outfits
#
#  id         :uuid             not null, primary key
#  era        :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Outfit < ApplicationRecord
  has_paper_trail

  include Erable

  has_one_attached :image

  # validations
  validates :era, presence: true
end
