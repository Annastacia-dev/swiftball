# == Schema Information
#
# Table name: mashup_answers
#
#  id          :uuid             not null, primary key
#  correct     :boolean          default(FALSE)
#  guest       :string
#  instrument  :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :uuid             not null
#  question_id :uuid             not null
#  response_id :uuid
#  song_id     :uuid             not null
#
# Indexes
#
#  index_mashup_answers_on_album_id     (album_id)
#  index_mashup_answers_on_question_id  (question_id)
#  index_mashup_answers_on_response_id  (response_id)
#  index_mashup_answers_on_song_id      (song_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (response_id => responses.id)
#  fk_rails_...  (song_id => songs.id)
#
require "test_helper"

class MashupAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
