# == Schema Information
#
# Table name: setlist_songs
#
#  id         :uuid             not null, primary key
#  era        :integer          default("lover")
#  length     :integer          default("full")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  setlist_id :uuid             not null
#  song_id    :uuid             not null
#
# Indexes
#
#  index_setlist_songs_on_setlist_id  (setlist_id)
#  index_setlist_songs_on_song_id     (song_id)
#
# Foreign Keys
#
#  fk_rails_...  (setlist_id => setlists.id)
#  fk_rails_...  (song_id => songs.id)
#
class SetlistSong < ApplicationRecord

  # associations
  belongs_to :setlist
  belongs_to :song

  include Erable

  enum length:{
    full: 0,
    shortened: 1
  }

  # instance methods
  def self.length_options
    lengths.map { |k, _v| [k.humanize, k] }
  end
end
