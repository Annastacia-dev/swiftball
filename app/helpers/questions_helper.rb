module QuestionsHelper
  def question_dropdown_items(question)
    quiz = question.quiz
    items = [
      { path: history_quiz_question_path(quiz, question), icon_class: 'fa-solid fa-clock-rotate-left', menu_text: 'View history' },
      { path: quiz_question_path(quiz, question), icon_class: 'fa-solid fa-circle-question', menu_text: 'View Question' },
      { path: edit_quiz_question_path(quiz, question), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Question' }
    ]

    if question.include_album_and_song
      items << { path: pick_surprise_song_quiz_question_path(quiz, question), icon_class: 'fa-solid fa-circle-check', menu_text: 'Pick Surprise Songs' }
    else
      items << { path: new_quiz_question_choice_path(quiz, question), icon_class: 'fa-solid fa-circle-check', menu_text: 'Add a Choice' }
    end

    items.push( { path: quiz_question_path(quiz, question), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Question', type:'button', method: 'delete' })

    items
  end

  def era_text_color(era)
    case era.downcase
    when 'lover'
      'text-rose-500'
    when 'fearless'
      'text-yellow-500'
    when 'red'
      'text-red-600'
    when 'speak_now'
      'text-violet-500'
    when 'folkmore'
      'text-orange-700'
    when '1989'
      'text-blue-500'
    when 'reputation'
      'dark:text-red-500 text-black'
    when 'the_tortured_poets_department'
      'text-gray-500 dark:text-gray-100'
    when 'acoustic_set'
      'text-lime-500'
    when 'midnights'
      'text-blue-950'
    when 'extra'
      'text-orange-500'
    when 'folklore'
      'text-gray-500 dark:text-gray-100'
    when 'evermore'
      'text-orange-900 dark:text-orange-300'
    else
      'text-blue-500'
    end
  end

  def album_color(album)
    case album.downcase
    when 'lover'
      'text-rose-500'
    when 'fearless'
      'text-yellow-600'
    when 'red'
      'text-red-600'
    when 'speak now'
      'text-violet-500'
    when 'folklore'
      'text-gray-500'
    when 'evermore'
      'text-yellow-600'
    when '1989'
      'text-blue-500'
    when 'ttpd'
      'text-gray-500'
    when 'debut'
      'text-lime-500'
    when 'midnights'
      'text-blue-950'
    when 'non-album'
      'text-orange-500'
    when 'reputation'
      'text-black'
    else
      'text-black'
    end
  end
end
