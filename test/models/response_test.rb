# == Schema Information
#
# Table name: responses
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  attempt_id :uuid             not null
#  choice_id  :uuid             not null
#
# Indexes
#
#  index_responses_on_attempt_id  (attempt_id)
#  index_responses_on_choice_id   (choice_id)
#
# Foreign Keys
#
#  fk_rails_...  (attempt_id => attempts.id)
#  fk_rails_...  (choice_id => choices.id)
#
require "test_helper"

class ResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
