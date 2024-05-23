# == Schema Information
#
# Table name: albums
#
#  id         :uuid             not null, primary key
#  slug       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Album < ApplicationRecord
  has_paper_trail

  include Sluggable
  friendly_slug_scope to_slug: :title

  # associations
  has_many :songs

  # validations
  validates :title, presence: true, uniqueness: true


  # callbacks
  before_save :downcase_title

  private

  def downcase_title
    self.title = title.downcase
  end
end
