# == Schema Information
#
# Table name: quizzes
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tour_id    :uuid             not null
#
# Indexes
#
#  index_quizzes_on_tour_id  (tour_id)
#
# Foreign Keys
#
#  fk_rails_...  (tour_id => tours.id)
#
class Quiz < ApplicationRecord
  belongs_to :tour
end
