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

  def piano_question_content
    'pick piano acoustic set album and song'
  end

  def guitar_question_content
    'pick guitar acoustic set album and song'
  end

  def question_icon(question_content)
    if question_content == guitar_question_content
      'icons/guitar.png'
    elsif question_content == piano_question_content
      'icons/piano.png'
    end
  end

  def mashup_score(mashup, response, piano_points, guitar_points)
    correct_albums = response.question.mashup_answers.where(response_id: nil, correct: true).pluck(:album_id)
    correct_songs = response.question.mashup_answers.where(response_id: nil, correct: true).pluck(:song_id)

    points = 0

    if correct_albums.include?(mashup.album_id) && correct_songs.include?(mashup.song_id)
      points = (response.question.id == piano_question.id ? piano_points : guitar_points) * 2
    elsif correct_albums.include?(mashup.album_id)
      points = response.question.id == piano_question.id ? piano_points : guitar_points
    elsif correct_songs.include?(mashup.song_id)
      points = response.question.id == guitar_question.id ? guitar_points : piano_points
    end

    points
  end
end