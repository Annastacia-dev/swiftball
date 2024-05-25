# == Schema Information
#
# Table name: mashup_answers
#
#  id          :uuid             not null, primary key
#  correct     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  album_id    :uuid             not null
#  attempt_id  :uuid
#  question_id :uuid             not null
#  song_id     :uuid             not null
#
# Indexes
#
#  index_mashup_answers_on_album_id     (album_id)
#  index_mashup_answers_on_attempt_id   (attempt_id)
#  index_mashup_answers_on_question_id  (question_id)
#  index_mashup_answers_on_song_id      (song_id)
#
# Foreign Keys
#
#  fk_rails_...  (album_id => albums.id)
#  fk_rails_...  (attempt_id => attempts.id)
#  fk_rails_...  (question_id => questions.id)
#  fk_rails_...  (song_id => songs.id)
#
class MashupAnswer < ApplicationRecord
  belongs_to :question
  belongs_to :attempt
  belongs_to :album
  belongs_to :song
end