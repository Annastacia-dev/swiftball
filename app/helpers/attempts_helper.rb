module AttemptsHelper
  def attempt_dropdown_items(quiz)
    attempt = current_user.attempts.find_by(quiz_id: quiz.id)

    if attempt
      items = [
        { path: attempt_path(attempt), icon_class: 'fa-solid fa-wand-magic-sparkles', menu_text: 'View Predictions' },
      ]

      if quiz.tour.status == 'open'
        items << { path: edit_attempt_path(attempt), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Predictions' }
      end
    end

    items
  end
end