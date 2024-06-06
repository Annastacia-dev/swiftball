namespace :db do
  namespace :data do
    desc 'Add abbreviations to albums'
    task add_abbreviations_to_albums: :environment do
      AddAbbreviationsToAlbums.call
    end
  end
end