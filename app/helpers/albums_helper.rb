module AlbumsHelper
  def album_dropdown_items(album)
    items = [
      { path: album_path(album), icon_class: 'fa-solid fa-record-vinyl', menu_text: 'View Album' },
      { path: edit_album_path(album), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Album' }
    ]

    if action_name == 'show'
      items <<  { path: new_album_song_path(album), icon_class: 'fa-solid fa-guitar', menu_text: 'Add a Song', type: 'drawer', id: 'new_song', view: 'albums/new_song' }
    end

    items.push << { path: album_path(album), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Album', type: 'button', method: 'delete' }

    items
  end

  def song_dropdown_items(song)
    album = song.album
    items = [
      { path: edit_album_song_path(album, song), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Song' },
      { path: album_song_path(album, song), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Song', type:'button', method: 'delete' },
    ]
    items
  end

  def album_bg_color(album)
    case album.downcase
    when 'debut'
      'bg-emerald-600 text-white'
    when 'fearless'
      'bg-yellow-200 text-yellow-950'
    when 'speak now'
      'bg-violet-800 text-violet-50'
    when 'red'
      'bg-red-600 text-white'
    when '1989'
      'bg-blue-400 text-blue-50'
    when 'reputation'
      'bg-zinc-950 text-white'
    when 'lover'
      'bg-rose-200 text-rose-900'
    when 'folklore'
      'bg-gray-200 text-black'
    when 'evermore'
      'bg-amber-950 text-white'
    when 'midnights'
      'bg-blue-950 text-white'
    when 'ttpd'
      'bg-zinc-600 text-white'
    when 'non-album'
      'bg-fuchsia-600'
    end
  end
end