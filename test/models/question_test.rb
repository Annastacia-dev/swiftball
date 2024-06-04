# == Schema Information
#
# Table name: questions
#
#  id                     :uuid             not null, primary key
#  choices_count          :integer          default(0)
#  content                :text
#  era                    :integer          default("lover")
#  guitar_mashup          :boolean          default(FALSE)
#  include_album_and_song :boolean          default(FALSE)
#  piano_mashup           :boolean          default(FALSE)
#  points                 :integer
#  position               :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  quiz_id                :uuid             not null
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#
require "test_helper"

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
