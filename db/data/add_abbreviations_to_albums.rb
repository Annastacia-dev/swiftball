# Add abbreviations to albums
class AddAbbreviationsToAlbums
  def self.call
    puts '[Data Migration] Adding abbreviations to albums.'
    albums = Album.where(abbr: nil)
    puts "Found #{albums.size} albums to update.."
    ActiveRecord::Base.transaction do
      albums.each_with_index do |album, index|
        puts "#{index + 1} / #{albums.size} Processing Album: #{album.title}"
        album.update!(abbr: album.title)
      end

      puts "Updating TTPD Abbreviation"
      ttpd_album = Album.find_by_title('the tortured poets department')
      puts "Found #{ttpd_album.title}"
      ttpd_album.update!(abbr: 'TTPD')

      puts "Updating Non Album Abbreviation"
      non_album = Album.find_by_title('non-album single (movie soundtrack, collab, unreleased)')
      puts "Found #{non_album.title}"
      non_album.update!(abbr: 'non-album')
    end
  end
end
