module SetlistsHelper
  def setlist_dropdown_items(setlist)
    items = [
      { path: setlist_path(setlist), icon_class: 'fa-solid fa-record-vinyl', menu_text: 'View Setlist' },
      { path: edit_setlist_path(setlist), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Setlist' }
    ]

    if action_name == 'show'
      items <<  { path: new_setlist_setlists_song_path(setlist), icon_class: 'fa-solid fa-guitar', menu_text: 'Add a Song', type: 'drawer', id: 'new_setlist_song', view: 'setlists/new_song' }
    end

    items.push << { path: setlist_path(setlist), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Setlist', type: 'button', method: 'delete' }

    items
  end

  def setlist_song_dropdown_items(song)

    [{ path: setlist_setlists_song_path(song.setlist, song), icon_class: 'fa-solid fa-delete-left', menu_text: 'Remove Song', type: 'button', method: 'delete' }]
  end

  def is_in_setlist?(song)
    Setlist.find_by(status: :current)&.setlist_songs.find_by(song_id: song.id)&.present?
  end
end