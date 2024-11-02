# == Schema Information
#
# Table name: attempts
#
#  id             :uuid             not null, primary key
#  final_position :integer
#  final_score    :integer
#  slug           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  quiz_id        :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_attempts_on_quiz_id  (quiz_id)
#  index_attempts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (quiz_id => quizzes.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class AttemptTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
