# == Schema Information
#
# Table name: songs
#
#  id         :uuid             not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  album_id   :uuid             not null
#
# Indexes
#
#  index_songs_on_album_id  (album_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#
class Song < ApplicationRecord
  has_paper_trail

  # associations
  belongs_to :album

  # validations
  validates :title, presence: true, uniqueness: true

  # callbacks
  before_save :downcase_title

  private

  def downcase_title
    self.title = title.downcase
  end
end
