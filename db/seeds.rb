# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Base Question
puts 'Creating Base Questions ...'

tour = Tour.create!(
  title: 'Base Tour',
  number: 1,
  date: Date.today,
  start_time: Time.now,
  timezone: 'Africa/Nairobi',
  base: true,
  status: :open
)

puts "Created #{tour.title}"

quiz = Quiz.find_by(tour_id: tour.id)

puts "Found quiz #{quiz.title}"

puts 'Lover Era Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'lover',
  points: 5,
  content: 'Lover Bodysuit Prediction'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'lover',
  points: 2,
  content: 'The Man Jacket'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'lover',
  points: 2,
  content: 'The Lover Guitar '
)

puts 'Fearless Era Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'fearless',
  points: 5,
  content: 'Fearless Dress'
)

puts 'Red Era Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'red',
  points: 5,
  content: '22 Shirt'
)

