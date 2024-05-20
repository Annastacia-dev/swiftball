# == Schema Information
#
# Table name: questions
#
#  id         :uuid             not null, primary key
#  content    :text
#  era        :integer          default(0)
#  points     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :uuid             not null
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
