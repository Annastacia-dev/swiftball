module ChoicesHelper
  def choice_dropdown_items(choice)
    items = [
      { path: correct_choice_path(choice), icon_class: 'fa-solid fa-circle-check', menu_text: 'Mark As Correct', type: 'button', method: 'post' },
      { path: edit_choice_path(choice), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit choice' },
      { path: choice_path(choice), icon_class: 'fa-solid fa-delete-left', menu_text: 'Remove Choice', type:'button', method: 'delete' }
    ]

    items
  end
end
