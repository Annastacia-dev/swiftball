# == Schema Information
#
# Table name: attempts
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :uuid             not null
#  user_id    :uuid             not null
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
class Attempt < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :quiz
end
