module ChoicesHelper
  def choice_dropdown_items(choice)
    items = [
      { path: edit_choice_path(choice), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit choice' },
      { path: choice_path(choice), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Choice', type:'button', method: 'delete' }
    ]

    if !choice.correct
      items.unshift({ path: correct_choice_path(choice), icon_class: 'fa-solid fa-circle-check', menu_text: 'Mark As Correct', type: 'button', method: 'post', button_class:  'mark-correct-button' })
    else
      items.unshift({ path: incorrect_choice_path(choice), icon_class: 'fa-solid fa-xmark', menu_text: 'Mark As incorrect', type: 'button', method: 'post' })
    end

    items
  end

  def label_description(label)
    case label.downcase
    when 'vulnarable'
      5
    when 'on_alert'
      7
    when 'endangered'
      10
    when 'critical'
      17
    when 'hibernating'
      30
    when 'extinct'
      50
    when 'retired'
      'previous setlist'
    end
  end

  def label_title(label)
    if label != 'retired'
      "Missing for #{label_description(label)} + shows"
    else
      label_description(label)
    end
  end

  def label_color(label)
    case label.downcase
    when 'vulnarable'
      'bg-yellow-400 text-black'
    when 'on_alert'
      'bg-orange-500 text-white'
    when 'endangered'
      'bg-rose-500 text-white'
    when 'critical'
      'bg-red-500 text-white'
    when 'hibernating'
      'bg-pink-600 text-white'
    when 'extinct'
      'bg-violet-950 text-white'
    when 'retired'
      'bg-gray-700 text-white'
    end
  end
end
