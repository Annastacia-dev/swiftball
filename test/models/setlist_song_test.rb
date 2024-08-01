# == Schema Information
#
# Table name: setlist_songs
#
#  id         :uuid             not null, primary key
#  era        :integer          default(0)
#  length     :integer          default(0)
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
require "test_helper"

class SetlistSongTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
