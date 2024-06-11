module OutfitsHelper
  def outfit_dropdown_items(outfit)
    [
      { path: edit_outfit_path(outfit), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Outfit' },
      { path: outfit_path(outfit), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Outfit', type: 'button', method: 'delete' },
    ]
  end
end