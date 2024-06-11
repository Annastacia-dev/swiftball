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
end
