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
class Choice < ApplicationRecord
  has_paper_trail

  has_one_attached :image

  include Searchable
  searchable against: %i[outfit_codename content]

  # association
  belongs_to :question, counter_cache: true, dependent: :destroy
  has_many :responses, dependent: :destroy

  # validations
  validates :content, presence: true, uniqueness: { scope: :question_id }
  validates :position, presence: true, uniqueness: { scope: :question_id }
  validate :tour_is_closed_before_marking_correct,  if: :correct_changed?
  validate :only_one_correct_answer_per_question, if: :correct_changed?

  # callbacks
  before_validation :set_position
  before_save :set_outfit_codename_to_nil_if_empty

  # enums
  enum label: {
    no_label: 0,
    vulnarable: 1,
    on_alert: 2,
    endangered: 3,
    critical: 4,
    hibernating: 5,
    extinct: 6,
    retired: 7
  }

  # scopes

  # class methods
  def self.labels_options
    labels.map { |k, _v| [k.humanize, k] }
  end

  def self.with_label(label)
    tour = Tour.order(number: :desc).first
    quiz = tour&.quiz
    quiz.choices.where(label: labels[label.to_sym])
  end

  # instance methods
  def percentage_of_total_responses
    total_responses = question.responses.count
    choice_responses = responses.count
    return 0 if total_responses.zero?

    ((choice_responses.to_f / total_responses) * 100).round
  end

  def outfits
    Choice.where(outfit_codename: self.outfit_codename)
  end

  def first_seen
    earliest_choice = outfits.where(correct: true)
           .joins(question: { quiz: :tour })
            .order('tours.start_time ASC')
            .first

    earliest_choice&.question&.quiz&.tour
  end

  def last_seen
    earliest_choice = outfits.where(correct: true)
           .joins(question: { quiz: :tour })
            .order('tours.start_time DESC')
            .first

    earliest_choice&.question&.quiz&.tour
  end

  def times_worn
    outfits.where(correct: true).count
  end

  def shows_since_last_seen
    last_seen_tour = last_seen

    return 0 unless last_seen_tour

    Tour.where(status: [:closed, :live]).where('start_time > ?', last_seen_tour.start_time).count
  end

  def available
    if first_seen
      Tour.where(status: [:live, :closed]).where.not(number: nil).order(number: :desc).first.number - first_seen&.number
    else
      nil
    end
  end

  def update_choice_label
    return if self.new_item == true

    return if self.outfit_codename == nil || self.outfit_codename == ''

    return if self.label == 'retired'

    case shows_since_last_seen
    when 5..7
      self.update(label: :vulnarable)
    when 7..9
      self.update(label: :on_alert)
    when 10..16
      self.update(label: :endangered)
    when 17..29
      self.update(label: :critical)
    when 30..49
      self.update(label: :hibernating)
    when 49..Float::INFINITY
      self.update(label: :extinct)
    else
      self.update(label: :no_label)
    end
  end

  private

  def set_outfit_codename_to_nil_if_empty
    if outfit_codename == ''
      self.outfit_codename == nil
    end
  end

  def set_position
    if position.nil?
      max_position = question.choices.maximum(:position) || 0
      new_item = question.choices.find_by(new_item: true)
      new_item_position = new_item&.position

      if new_item_position
        self.position = new_item_position
        new_item.update(position: new_item_position + 1)
      else
        if max_position
          self.position = max_position + 1
        end
      end
    end
  end

  def tour_is_closed_before_marking_correct
    if correct == true && ( question.quiz.tour.status != 'closed' && question.quiz.tour.status != 'live' )
      errors.add(:base, "Please close the quiz before choosing correct answers")
    end
  end

  def only_one_correct_answer_per_question
    correct_answer = question.choices.find_by(correct: true)
    if correct_answer && correct === true
      errors.add(:base, "A correct answer already exists mark it as false then choose another one")
    end
  end
end
