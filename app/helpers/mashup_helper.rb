module MashupHelper
  def mashup_max_score(ans)
    max_points = 0
    case ans&.downcase
    when 'no mashup'
      max_points = 3
    when 'mashup (2 songs) '
      max_points = 1.5
    when 'mashup (3 songs)'
      max_points = 1
    when 'mashup (4+ songs)'
      max_points = 0.75
    else
      max_points = 0
    end
  end

  def format_score(number)
    if number == number.to_i
      number.to_i.to_s
    else
      number.to_s
    end
  end

  def mashup_dropdown_items(mashup)
    switch = mashup.instrument == 'guitar' ? 'piano' : 'guitar'
    items = [
      { path: edit_mashup_answer_path(mashup), icon_class: 'fa-solid fa-pencil', menu_text: 'Edit' },
      { path: switch_instrument_mashup_answer_path(mashup), icon_class: 'fa-solid fa-toggle-on', menu_text: "Switch to #{switch}", type:'button', method: 'patch' },
      { path: add_guest_mashup_answer_path(mashup), icon_class: 'fa-solid fa-user', menu_text: "Add Guest" }
    ]
  end
end