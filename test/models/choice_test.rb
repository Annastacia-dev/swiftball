# == Schema Information
#
# Table name: choices
#
#  id              :uuid             not null, primary key
#  content         :string
#  correct         :boolean          default(FALSE)
#  label           :integer          default("no_label")
#  new_item        :boolean          default(FALSE)
#  outfit_codename :string
#  position        :integer
#  responses_count :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  question_id     :uuid             not null
#
# Indexes
#
#  index_choices_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
require "test_helper"

class ChoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
