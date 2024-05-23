module QuestionsHelper
  def question_dropdown_items(question)
    quiz = question.quiz
    items = [
      { path: quiz_question_path(quiz, question), icon_class: 'fa-solid fa-circle-question', menu_text: 'View Question' },
      { path: edit_quiz_question_path(quiz, question), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Question' },
      { path: new_quiz_question_choice_path(quiz, question), icon_class: 'fa-solid fa-circle-check', menu_text: 'Add a Choice' },
      { path: quiz_question_path(quiz, question), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete Quiz', type:'button', method: 'delete' },
    ]
  end
end
