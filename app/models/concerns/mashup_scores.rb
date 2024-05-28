# Determine piano and guitar question mashup points

module MashupScores

  def piano_mashup_score

    pm_score = 0

    piano_mashup_number_question = quiz.questions.find_by(piano_mashup: true)
    piano_mashup_number_choice = responses.find_by(question_id: piano_mashup_number_question.id).choice

    question_content = 'Pick Piano Acoustic Set Album and Song'
    piano_question = quiz.questions.find_by(content: question_content)

    piano_mashup_predictions = responses.flat_map do |response|
      response.mashup_answers.where(question_id: piano_question.id)
    end

    piano_correct_mashups = piano_question.mashup_answers.where(response_id: nil, correct: true)
    piano_correct_albums = piano_correct_mashups.pluck(:album_id)
    piano_correct_songs = piano_correct_mashups.pluck(:song_id)

    points = mashup_max_score(piano_mashup_number_choice.content)

    piano_mashup_predictions.each do |mashup|

      if piano_correct_albums.include?(mashup.album_id)
        pm_score += points
      end

      if piano_correct_songs.include?(mashup.song_id)
        pm_score += points
      end
    end

    pm_score
  end

  def guitar_mashup_score

    gm_score = 0

    guitar_mashup_number_question = quiz.questions.find_by(guitar_mashup: true)
    guitar_mashup_number_choice = responses.find_by(question_id: guitar_mashup_number_question.id).choice

    question_content = 'Pick Guitar Acoustic Set Album and song'
    guitar_question = quiz.questions.find_by(content: question_content)

    guitar_mashup_predictions = responses.flat_map do |response|
      response.mashup_answers.where(question_id: guitar_question.id)
    end

    guitar_correct_mashups = guitar_question.mashup_answers.where(response_id: nil, correct: true)
    guitar_correct_albums = guitar_correct_mashups.pluck(:album_id)
    guitar_correct_songs = guitar_correct_mashups.pluck(:song_id)

    points = mashup_max_score(guitar_mashup_number_choice.content)

    guitar_mashup_predictions.each do |mashup|

      if guitar_correct_albums.include?(mashup.album_id)
        gm_score += points
      end

      if guitar_correct_songs.include?(mashup.song_id)
        gm_score += points
      end
    end

    gm_score
  end

end