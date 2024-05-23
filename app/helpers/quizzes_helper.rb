module QuizzesHelper

  def era_color(era)
    case era.downcase
    when 'lover'
      'bg-rose-200 text-rose-900'
    when 'fearless'
      'bg-yellow-200 text-yellow-900'
    when 'red'
      'bg-red-600 text-white'
    when 'speak_now'
      'bg-violet-200 text-violet-900'
    when 'folkmore'
      'bg-gray-200 text-orange-700'
    when '1989'
      'bg-blue-100 text-blue-500'
    when 'the_tortured_poets_department'
      'bg-gray-100 text-gray-500'
    when 'acoustic_set'
      'bg-gradient bg-lime-100 text-lime-900'
    when 'midnights'
      'bg-gradient bg-blue-950 text-white'
    when 'extra'
      'bg-gradient bg-orange-500 text-white'
    else
      'bg-black text-white'
    end
  end

  def quiz_dropdown_items(quiz)
    items = [
      { path: quiz_path(quiz), icon_class: 'fa-solid fa-circle-question', menu_text: 'View Quiz' },
      { path: new_quiz_question_path(quiz), icon_class: 'fa-solid fa-clipboard-question', menu_text: 'Add a Question' },
      { path: quiz_path(quiz), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Quiz', type:'button', method: 'delete' },
    ]

    if quiz.tour.status == 'pending' || quiz.tour.status == 'open'
      items << { path: edit_tour_path(quiz.tour), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Quiz' }
    end

    if quiz.tour.status != 'open'
      items << { path: open_quiz_path(quiz), icon_class: 'fa-solid fa-wand-magic-sparkles', menu_text: 'Open Quiz', type:'button', method: 'post' }
    end

    if quiz.tour.status != 'closed'
      items << { path: close_quiz_path(quiz), icon_class: 'fa-solid fa-xmark', menu_text: 'Close Quiz', type:'button', method: 'post' }
    end

    items
  end
end
