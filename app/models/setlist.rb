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
class Setlist < ApplicationRecord

  # associations
  belongs_to :tour, optional: true
  has_many :setlist_songs, dependent: :destroy

  # enums
  enum status:{
    previous: 0,
    current: 1
  }

  # instance methods
  def self.status_options
    statuses.map { |k, _v| [k.humanize, k] }
  end
end
