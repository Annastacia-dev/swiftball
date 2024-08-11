# == Schema Information
#
# Table name: openers
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Opener < ApplicationRecord
  has_paper_trail

  # associations
  has_and_belongs_to_many :tours

  # validations
  validates :name, presence: true, uniqueness: true
end
