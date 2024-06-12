module QuestionsHelper
  def question_dropdown_items(question)
    quiz = question.quiz
    items = [
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
    when 'the_tortured_poets_department'
      'text-gray-500'
    when 'acoustic_set'
      'text-lime-500'
    when 'midnights'
      'text-blue-950'
    when 'extra'
      'text-orange-500'
    else
      'text-blue-500'
    end
  end
end
