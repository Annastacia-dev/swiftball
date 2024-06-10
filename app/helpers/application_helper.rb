module ApplicationHelper

  def navbar_items
    items = [
      { path: root_path, icon_class: 'fa-solid fa-house', menu_text: 'Home' },
      { path: edit_user_registration_path, icon_class: 'fa-solid fa-user', menu_text: 'Profile' }
    ]

    if current_user.admin?
      items.insert(1, { path: albums_path, icon_class: 'fa-solid fa-record-vinyl', menu_text: 'Albums'})
      items << ( { path: users_path, icon_class: 'fa-solid fa-user', menu_text: 'Users'})
    else
      items << ({ path: stats_path, icon_class: 'fa-solid fa-chart-simple', menu_text: 'Statistics' })
      items << ({ path: 'https://ko-fi.com/annetotoh/goal?g=0', icon_class: 'fa-solid fa-server', menu_text: 'Help Keep Servers Running' })
    end

    items.push({ path: terms_and_conditions_path, icon_class: 'fa-regular fa-newspaper', menu_text: 'Terms & Conditions'})

    items.push({ path: privacy_policy_path, icon_class: 'fa-solid fa-user-lock', menu_text: 'Privacy Policy'})

    items.push({ path: disclaimer_path, icon_class: 'fa-solid fa-triangle-exclamation', menu_text: 'Disclaimer'})

    items.push({ path: destroy_user_session_path, icon_class: 'fa-solid fa-right-from-bracket', menu_text: 'Logout', type: 'button', method: :delete })

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
      "#757575","#757575", "#757575","#757575",
      "#dce775","#dce775","#dce775","#dce775","#dce775",
      "#1a237e", "#1a237e", "#1a237e",
      "#ff5722", "#ff5722",
      ""
    ]
  end

  def chart_types
    ['line_chart', 'column_chart', 'bar_chart', 'pie_chart']
  end

  def render_chart(data, title, empty_statement, data_type)
    @chart_type = params[:chart_type] || 'bar_chart'
    case @chart_type
    when 'line_chart', 'column_chart', 'bar_chart', 'pie_chart'
      send(@chart_type, data, download: { title: title }, empty: empty_statement, legend: false, donut: true, height: @chart_type != 'pie_chart' ? data_type == 'eras' ? '400px' : '1000px' : '', colors: data_type == 'eras' ? eras_bar_chart_colors : questions_bar_chart_colors)
    else
      raise ArgumentError, "Invalid chart type: #{@chart_type}"
    end
  end
end
