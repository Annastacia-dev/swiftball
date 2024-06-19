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
end