module AttemptsHelper
  def attempt_dropdown_items(quiz)
    attempt = current_user.attempts.find_by(quiz_id: quiz.id)

    if attempt
      items = []

      if quiz.tour.status == 'open'
        items << { path: attempt_path(attempt), icon_class: 'fa-solid fa-wand-magic-sparkles', menu_text: 'View Predictions' }

        items << { path: edit_attempt_path(attempt), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit Predictions' }
      end

      if quiz.tour.status == 'live'
        items << { path: attempt_path(attempt), icon_class: 'fa-solid fa-square-poll-vertical', menu_text: 'View Progress' }
      end

      if quiz.tour.status == 'closed'
        items << { path: attempt_path(attempt), icon_class: 'fa-solid fa-square-poll-vertical', menu_text: 'View Results' }
      end

      items <<         { path: download_pdf_attempt_path(attempt), icon_class: 'fa-solid fa-file-pdf', menu_text: 'Download PDF' }
    end

    items
  end

  def attempt_badge(position)
    case position
    when 1
      'trophy.png'
    when 2
      'badge2.png'
    when 3
      'badge3.png'
    end
  end

  def attempt_badge_class(position)
    case position
    when 1
      'w-8  -ml-2'
    when 2
      'w-6 -ml-1'
    when 3
      'w-6 -ml-1'
    end
  end
end