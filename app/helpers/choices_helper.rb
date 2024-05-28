module ChoicesHelper
  def choice_dropdown_items(choice)
    items = [
      { path: edit_choice_path(choice), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit choice' },
      { path: choice_path(choice), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Choice', type:'button', method: 'delete' }
    ]

    if !choice.correct
      items.unshift({ path: correct_choice_path(choice), icon_class: 'fa-solid fa-circle-check', menu_text: 'Mark As Correct', type: 'button', method: 'post' })
    else
      items.unshift({ path: incorrect_choice_path(choice), icon_class: 'fa-solid fa-xmark', menu_text: 'Mark As incorrect', type: 'button', method: 'post' })
    end

    items
  end
end
