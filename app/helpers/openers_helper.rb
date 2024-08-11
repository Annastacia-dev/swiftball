module OpenersHelper
  def opener_dropdown_items(opener)
    [
      { path: opener_path(opener), icon_class: 'fa-solid fa-microphone', menu_text: 'View opener' },
      { path: edit_opener_path(opener), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit opener' },
      { path: opener_path(opener), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete opener', type: 'button', method: 'delete' }
    ]
  end
end