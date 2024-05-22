# == Schema Information
#
# Table name: quizzes
#
#  id         :uuid             not null, primary key
#  slug       :string
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
  has_paper_trail

  include Sluggable
  friendly_slug_scope to_slug: :title

  # associations
  belongs_to :tour, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy

  def total_attempts
    attempts.size
  end

  # instance methods
  def title
    tour.title
  end
end
