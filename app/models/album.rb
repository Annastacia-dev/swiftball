# == Schema Information
#
# Table name: albums
#
#  id         :uuid             not null, primary key
#  abbr       :string
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
  has_many :songs, dependent: :destroy
  has_many :mashup_answers, dependent: :destroy

  # validations
  validates :title, presence: true, uniqueness: true


  # callbacks
  before_save :downcase_title

  private

  def downcase_title
    self.title = title.downcase
  end
end
