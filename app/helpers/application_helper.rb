module ApplicationHelper

  def sidebar_items
    items = [ { path: root_path, icon_class: 'fa-solid fa-house', menu_text: 'Home' } ]

    if current_user.admin?
      items.push(
        path: '',
        icon_class: 'fa-solid fa-music',
        menu_text: 'Music',
        children: [
          { path: albums_path, icon_class: 'fa-solid fa-record-vinyl', menu_text: 'Albums'},
          { path: surprise_songs_path, icon_class: 'fa-solid fa-guitar', menu_text: 'Surprise Songs' },
          { path: setlists_path, icon_class: 'fa-solid fa-record-vinyl', menu_text: 'Setlists'},
          { path: openers_path, icon_class: 'fa-solid fa-microphone', menu_text: 'Openers'}
        ]
      )
      items.push(
        path: '',
        icon_class: 'fa-solid fa-shirt',
        menu_text: 'Outfits',
        children: [
          { path: tracker_outfits_path, icon_class: 'fa-solid fa-chart-line', menu_text: 'Tracker & Stats'},
          { path: new_outfit_path, icon_class: 'fa-solid fa-plus', menu_text: 'New Outfit'},
          { path: outfits_path, icon_class: 'fa-regular fa-images', menu_text: 'Gallery'}
        ]
      )
      items << { path: feedbacks_path, icon_class: 'fa-solid fa-message', menu_text: 'Feedback'}
    else
      items.insert(1, { path: stats_path, icon_class: 'fa-solid fa-chart-simple', menu_text: 'Statistics' })
      items.push(
        path: '',
        icon_class: 'fa-solid fa-music',
        menu_text: 'Music',
        children: [
          { path: surprise_songs_path, icon_class: 'fa-solid fa-guitar', menu_text: 'Surprise Songs' },
          { path: setlists_path, icon_class: 'fa-solid fa-record-vinyl', menu_text: 'Setlists'}
        ]
      )
      items << {
        path: '',
        icon_class: 'fa-solid fa-shirt',
        menu_text: 'Outfits',
        children: [
          { path: tracker_outfits_path, icon_class: 'fa-solid fa-chart-line', menu_text: 'Tracker & Stats'},
          { path: outfits_path, icon_class: 'fa-regular fa-images', menu_text: 'Gallery'}
        ]
      }
    end

    items.push(
      path: '',
      icon_class: 'fa-solid fa-gavel',
      menu_text: 'Legal',
      children: [
        { path: terms_and_conditions_path, icon_class: 'fa-regular fa-newspaper', menu_text: 'Terms & Conditions'},
        { path: privacy_policy_path, icon_class: 'fa-solid fa-user-lock', menu_text: 'Privacy Policy'},
        { path: disclaimer_path, icon_class: 'fa-solid fa-triangle-exclamation', menu_text: 'Disclaimer'},
        { path: credits_path, icon_class: 'fa-solid fa-clapperboard', menu_text: 'Credits'}
      ]
    )

    items.push(
      path: '',
      icon_class: 'fa-solid fa-user',
      menu_text: 'Profile',
      children: [
        { path: edit_user_registration_path, icon_class: 'fa-solid fa-pencil', menu_text: 'Edit' },
        { path: destroy_user_session_path, icon_class: 'fa-solid fa-right-from-bracket', menu_text: 'Logout', type: 'button', method: :delete },
        { path:  registration_path('user'), icon_class: 'fa-solid fa-delete-left', menu_text: 'Delete account', type: 'button', method: :delete, class: 'mt-10' }
      ]
    )

    if !current_user.admin?
      items << { path: 'https://ko-fi.com/swiftballonline', icon_class: 'fa-solid fa-mug-hot', menu_text: 'Buy A coffee' }
      items << { path: new_feedback_path, icon_class: 'fa-solid fa-message', menu_text: 'Feedback'}
    end

    items
  end

  def bottom_nav_links
    items = [
      { path: root_path, icon_class: 'fa-solid fa-house', menu_text: 'Home' },
      { path: leaderboard_path, icon_class: 'fa-solid fa-chess-board', menu_text: 'Leaderboard' },
      { path: surprise_songs_path, icon_class: 'fa-solid fa-guitar', menu_text: 'Surprise Songs' },
      { path: tracker_outfits_path, icon_class: 'fa-solid fa-shirt', menu_text: 'Outfits Tracker' }
    ]

    if current_user.admin?
      items << { path: new_tour_path, icon_class: 'fa-solid fa-plus', menu_text: 'New Tour' }
    end

    items
  end

  def notification_class(type)
    case type
    when 'alert'
      'border-red-500 bg-red-50 text-red-500'
    when 'notice'
      'border-blue-500 bg-blue-50 text-blue-500'
    when 'success'
      'border-green-500 bg-green-50 text-green-500'
    when 'error'
      'border-red-500 bg-red-50 text-red-500'
    when 'warning'
      'border-yellow-500 bg-yellow-50 text-yellow-500'
    when 'info'
      'border-blue-500 bg-blue-50 text-blue-500'
    else
      'border-gray-500 bg-gray-50 text-gray-500'
    end
  end

  def notification_icon(type)
    case type
    when 'alert'
      'fa-solid fa-circle-xmark'
    when 'notice'
      'fa-solid fa-info-circle'
    when 'success'
      'fa-solid fa-check-circle'
    when 'error'
      'fa-solid fa-exclamation-triangle'
    when 'warning'
      'fa-solid fa-circle-exclamation'
    when 'info'
      'fa-solid fa-circle-info'
    else
      'fa-solid fa-circle-info'
    end
  end

  def progress_bar_background(type)
    case type
    when 'alert'
      'bg-red-500'
    when 'notice'
      'bg-blue-500'
    when 'success'
      'bg-green-500'
    when 'error'
      'bg-red-500'
    when 'warning'
      'bg-yellow-500'
    when 'info'
      'bg-blue-500'
    else
      'bg-gray-500'
    end
  end

  def eras_bar_chart_colors
    [
      "#f06292",
      "#ffd54f",
      "#b71c1c",
      "#4a148c",
      "#000",
      "#ffe0b2",
      "#bbdefb",
      "#757575",
      "#dce775",
      "#1a237e",
      "#ff5722",
      ""
    ]
  end

  def questions_bar_chart_colors
    [
      "#f06292", "#f06292", "#f06292",
      "#ffd54f",
      "#b71c1c",
      "#4a148c",
      "#000",
      "#ffe0b2", "#ffe0b2",
      "#bbdefb", "#bbdefb",
      "#757575","#757575", "#757575","#757575", "#757575",
      "#dce775","#dce775","#dce775","#dce775","#dce775",
      "#1a237e", "#1a237e", "#1a237e",
      "#ff5722", "#ff5722",
      ""
    ]
  end

  def album_chart_colors
     [
      "#059669",
      "#fef08a",
      "#5b21b6",
      "#dc2626",
      "#60a5fa",
      "#000000",
      "#fecdd3",
      "#e5e7eb",
      "#451a03",
      "#172554",
      "#52525b",
      "#c026d3",
      ""
     ]
  end

  def chart_types
    ['line_chart', 'column_chart', 'bar_chart', 'pie_chart']
  end

  def render_chart(data, title, empty_statement, data_type, chart_type: 'bar_chart', height: '1000px')
    @chart_type = params[:chart_type] || chart_type
    case @chart_type
    when 'line_chart', 'column_chart', 'bar_chart', 'pie_chart'
      send(@chart_type, data, download: { title: title }, empty: empty_statement, legend: false, donut: true, height: height , colors: determine_chart_colors(data_type))
    else
      raise ArgumentError, "Invalid chart type: #{@chart_type}"
    end
  end

  def determine_chart_colors (data_type)
    case data_type
    when 'eras'
      eras_bar_chart_colors
    when 'albums'
      album_chart_colors
    else
      questions_bar_chart_colors
    end
  end

  def time_user_timezone(datetime, user)
     if Date.today.in_time_zone(user.timezone).to_date < datetime.to_date
       datetime_user_timezone(datetime, user)
     else
       datetime.in_time_zone(user.timezone).strftime('%I:%M %p')
     end
  end

  def datetime_user_timezone(datetime, user)
    datetime.in_time_zone(user.timezone).strftime("%A %d %B %Y %H:%M")
  end
end
