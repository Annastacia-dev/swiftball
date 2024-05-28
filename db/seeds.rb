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

puts 'Speak Now Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'speak_now',
  points: 8,
  content: 'Speak Now Dress'
)

puts 'Reputation Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'speak_now',
  points: 13,
  content: 'Reputation Bodysuit'
)

puts 'Folkmore Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'folkmore',
  points: 7,
  content: 'Folkmore Dress'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'folkmore',
  points: 3,
  content: 'How long will the Champagne Problems cheer last?'
)

puts '1989 Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: '1989',
  points: 6,
  content: '1989 set'
)

puts 'The Tortured Poets Department Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'the_tortured_poets_department',
  points: 2,
  content: 'Tortured Poet Dress'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'the_tortured_poets_department',
  points: 3,
  content: 'Broken Heart Set'
)

puts 'Acoustic Set Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 2,
  content: 'Surprise Song Dress'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 1,
  content: 'Will there be a Guitar Surprise Song Speech?'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 3,
  content: 'Will there be a Guitar Surprise Song Mashup?',
  guitar_mashup: true
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 6,
  content: 'pick Guitar Acoustic Set Album and song',
  include_album_and_song: true
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 1,
  content: 'Will there be a Piano Surprise Song Speech?'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 3,
  content: 'Will there be a Piano Surprise Song Mashup?',
  piano_mashup: true
)

Question.create!(
  quiz_id: quiz.id,
  era: 'acoustic_set',
  points: 6,
  content: 'Pick Piano Acoustic Set Album and Song',
  include_album_and_song: true
)

puts 'Midnights Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'midnights',
  points: 2,
  content: 'Midnights tshirt dress'
)

Question.create!(
  quiz_id: quiz.id,
  era: 'midnights',
  points: 3,
  content: 'Midnight Rain Bodysuit '
)

Question.create!(
  quiz_id: quiz.id,
  era: 'midnights',
  points: 3,
  content: 'Karma Jacket'
)

puts 'Extra Questions ...'

Question.create!(
  quiz_id: quiz.id,
  era: 'extra',
  points: 5,
  content: 'Will there be a special guest?'
)

puts "Questions created: #{Question.all.size}"

puts "Adding Albums"

album_titles = [
  'Debut',
  'Fearless',
  'Speak Now',
  'Red',
  '1989',
  'reputation',
  'lover',
  'folklore',
  'evermore',
  'midnights',
  'the tortured poets department',
  'non-album single (movie soundtrack, collab, unreleased)'
]

album_titles.each do |title|
  Album.create!(title: title)
end

puts "Created #{Album.count} albums."

puts "Seeding Debut songs"
debut_songs = [
  "tim mcgraw",
  "picture to burn",
  "teardrops on my guitar",
  "a place in this world",
  "cold as you",
  "the outside",
  "tied together with a smile",
  "stay beautiful",
  "should've said no",
  "mary's song ( oh my my my)",
  "our song",
  "i'm only me when i'm with you",
  "invisible",
  "a perfectly good heart"
]
debut_album = Album.find_by_title('debut')
debut_songs.each do |title|
  debut_album.songs.create!(title: title)
end
puts "Added debut songs"

puts "Seeding Fearless songs"
fearless_songs = [
    "Fearless",
    "Fifteen",
    "Love story",
    "Hey Stephen",
    "White horse",
    "You belong with me",
    "Breathe ft Colbie Caillat",
    "Tell me why",
    "You're not sorry",
    "The way I loved you",
    "Forever & always",
    "The best day",
    "Change",
    "Jump then fall",
    "Untouchable",
    "Come in with the rain",
    "Superstar",
    "The other side of the door",
    "Today was a fairy tale",
    "You all over me ft Marren Morris",
    "Mr perfectly fine",
    "That's when ft Keith Urban",
    "Don't you",
    "Bye bye baby"
]
fearless_album = Album.find_by_title('fearless')
fearless_songs.each do |title|
  fearless_album.songs.create!(title: title)
end
puts "Added fearless songs"

puts "Seeding Red songs"
red_songs = [
  "State of grace",
  "Red",
  "Treacherous",
  "I knew you were trouble",
  "All too well",
  "22",
  "I almost do",
  "We are never ever getting back together",
  "Stay stay stay",
  "The last time ft gary lightbody of snow patrol",
  "Holy ground",
  "Sad beautiful tragic",
  "The lucky one",
  "Everything has changed ft Ed sheeran",
  "Starlight",
  "Begin Again",
  "The moment I knew",
  "Come back...be here",
  "Girl at home",
  "Ronan",
  "Better man",
  "Nothing new ft Phoebe bridgers",
  "Babe",
  "Message in a bottle",
  "I bet you think about me ft Chris Stapleton",
  "Forever winter",
  "Run ft Ed sheeran",
  "The very first night"
];
red_album = Album.find_by_title('red')
red_songs.each do |title|
  red_album.songs.create!(title: title)
end
puts "Added red songs"


puts "Seeding speak now songs"
speak_now_songs = [
  "Mine",
  "Sparks fly",
  "Back to December",
  "Speak now",
  "Dear john",
  "Mean",
  "The story of us",
  "Never grow up",
  "Enchanted",
  "Better than revenge",
  "Innocent",
  "Haunted",
  "Last kiss",
  "Long live",
  "ours",
  "Superman",
  "Electric touch ft fall out boy",
  "When Emma falls in love",
  "I can see you",
  "Castles crumbling ft Hayley Williams",
  "Foolish one",
  "Timeless"
];
speak_now_album = Album.find_by_title('speak now')
speak_now_songs.each do |title|
  speak_now_album.songs.create!(title: title)
end
puts "Added speak now songs"

puts "Seeding 1989 songs"
birth_year_songs = [
  "Welcome to New york",
  "Blank space",
  "Style",
  "Out of the woods",
  "All you had to do was stay",
  "Shake it off",
  "I wish you would",
  "Bad blood",
  "Wildest dreams",
  "How you get the girl",
  "This love",
  "I know places",
  "Clean",
  "Wonderland",
  "You are in love",
  "New romatics",
  "Slut!",
  "Say don't go",
  "Now that we don't talk",
  "Suburban legends",
  "Is it over now",
  "Sweeter than fiction"
];
birth_year_album = Album.find_by_title('1989')
birth_year_songs.each do |title|
  birth_year_album.songs.create!(title: title)
end
puts "Added 1989 songs"


puts "Seeding reputation songs"
rep_songs = [
    "...Ready for It?",
    "End Game",
    "I Did Something Bad",
    "Don't Blame Me",
    "Delicate",
    "Look What You Made Me Do",
    "So It Goes...",
    "Gorgeous",
    "Getaway Car",
    "King of my heart",
    "Dancing with our hands tied",
    "Dress",
    "This is why we can't have nice things",
    "Call it want you want",
    "New years day"
]
rep_album = Album.find_by_title('reputation')
rep_songs.each do |title|
  rep_album.songs.create!(title: title)
end
puts "Added rep songs"

puts "Seeding lover songs"
lover_songs = [
    "I forgot that you existed",
    "Cruel summer",
    "Lover",
    "The man",
    "The archer",
    "I think he knows",
    "Miss Americana & the heartbreak Prince",
    "Paper rings",
    "Cornelian Street",
    "Death by a thousand cuts",
    "London boy",
    "Soon you'll get better",
    "False God",
    "You need to calm down",
    "Afterglow",
    "Me",
    "It's nice to have a friend",
    "Daylight",
    "All of the girls you loved before"
];

lover_album = Album.find_by_title('lover')
lover_songs.each do |title|
  lover_album.songs.create!(title: title)
end
puts "Added lover songs"


puts "Seeding folklore songs"
folklore_songs = [
     "the 1",
    "Cardigan",
    "The last great american dynasty",
    "Exile",
    "My tears ricochet",
    "Mirrorball",
    "Seven",
    "August",
    "This is me trying",
    "Illicit affairs",
    "Invisible string",
    "Mad woman",
    "Epiphany",
    "Betty",
    "Peace",
    "Hoax",
    "The lakes"
];

folklore_album = Album.find_by_title('folklore')
folklore_songs.each do |title|
  folklore_album.songs.create!(title: title)
end
puts "Added folklore songs"

puts "Seeding evermore songs"
evermore_songs = [
    "Willow",
    "Champagne problems",
    "Gold rush",
    "'Tis the damn season",
    "Tolerate it",
    "No body, no crime",
    "Happiness",
    "Dorothea",
    "Coney island",
    "Ivy",
    "Cowboy like me",
    "Long story short",
    "Marjorie",
    "Closure",
    "Evermore",
    "Right where you left me",
    "It's time to go"
];
evermore_album = Album.find_by_title('evermore')
evermore_songs.each do |title|
  evermore_album.songs.create!(title: title)
end
puts "Added evermore songs"


puts "Seeding midnights songs"
midnights_songs = [
    "Lavender haze",
    "Maroon",
    "Anti hero",
    "Snow on the beach",
    "You're on your own kid",
    "Midnight rain",
    "Question...?",
    "Vigilante shit",
    "Bejeweled",
    "Labyrinth",
    "Karma",
    "Sweet nothing",
    "Mastermind",
    "Hits different",
    "The great war",
    "Bigger than the whole sky",
    "Paris",
    "High infidelity",
    "Glitch",
    "Would've could've should've",
    "Dear reader",
    "You're losing me"
];
midnights_album = Album.find_by_title('midnights')
midnights_songs.each do |title|
  midnights_album.songs.create!(title: title)
end
puts "Added midnights songs"

puts "Seeding ttpd songs"
 ttpd_songs = [
    "Fortnight ft post malone",
    "The tortured poets department",
    "My boy only breaks his favorite toys",
    "Down bad",
    "So long London",
    "But daddy I love him",
    "Fresh out the slammer",
    "Florida ft Florence + the machine",
    "Guilty as sin",
    "Who's afraid of little old me",
    "I can fix him  (no really I can)",
    "Loml",
    "I can do it with a broken heart",
    "The smallest man who ever lived",
    "The alchemy",
    "Clara bow",
    "The black dog",
    "Imgonnagetyouback",
    "The albatross",
    "Chloe or Sam or Sophia or Marcus",
    "How did it end?",
    "So high school",
    "I hate it here",
    "ThanK you aIMee",
    "I look in people's windows",
    "The prophecy",
    "Cassandra",
    "Peter",
    "The bolter",
    "Robin",
    "The manuscript"
];
ttpd_album = Album.find_by_title('the tortured poets department')
ttpd_songs.each do |title|
  ttpd_album.songs.create!(title: title)
end
puts "Added ttpd songs"

puts "Seeding extra songs"
extra_songs = [
    "Safe & sound",
    "Eyes open",
    "Highway don't care by Tim Mcgraw with taylor swift ft Keith Urban",
    "I dont wanna live forever by Zayn malik ft taylor swift",
    "Christmas tree farm",
    "Two is better than one by boys like girls",
    "God bless the children by Wayne Warner",
    "Both of us by Bob",
    "Gasoline by Haim",
    "Renegade by Big Red machine",
    "The joker and the Queen ft Ed sheeran",
    "The alcott ft the nationals",
    "Beautiful ghosts, cats",
    "Caroline, where the crawdads sing",
    "Last Christmas",
    "Santa baby",
    "White Christmas",
    "Silent night",
    "Christmases when you were mine",
    "Umbrella",
    "Crazier, hannah montana",
    "only the young"
];
extra_album = Album.find_by_title('non-album single (movie soundtrack, collab, unreleased)')
extra_songs.each do |title|
  extra_album.songs.create!(title: title)
end
puts "Added extra songs"

puts "Done!"








