# Determine piano and guitar question mashup points

module MashupScores

  def piano_mashup_score

    pm_score = 0

    @piano_mashup_number_question = quiz&.questions.find_by(piano_mashup: true)

    if @piano_mashup_number_question
      @piano_mashup_number_choice = responses.find_by(question_id: @piano_mashup_number_question.id)&.choice

      @piano_question_content = 'pick piano acoustic set album and song'
      @piano_question = quiz&.questions.find_by(content: @piano_question_content)

      @piano_mashup_predictions = self.mashup_answers.where(question_id: @piano_question.id)

      return if @piano_mashup_predictions.nil?

      @piano_correct_mashups = @piano_question.mashup_answers.where(response_id: nil, correct: true)

      return if @piano_correct_mashups.nil?

      @piano_correct_albums = @piano_correct_mashups.pluck(:album_id)
      @piano_correct_songs = @piano_correct_mashups.pluck(:song_id)

      @piano_points = mashup_max_score(@piano_mashup_number_choice&.content)

      @piano_mashup_predictions.each do |mashup|

        if @piano_correct_albums.include?(mashup.album_id)
          pm_score += @piano_points
        end

        if @piano_correct_songs.include?(mashup.song_id)
          pm_score += @piano_points
        end
      end
    end

    pm_score
  end

  def guitar_mashup_score

    gm_score = 0

    @guitar_mashup_number_question = quiz&.questions.find_by(guitar_mashup: true)

    if @guitar_mashup_number_question

      @guitar_mashup_number_choice = responses.find_by(question_id: @guitar_mashup_number_question.id)&.choice

      @guitar_question_content = 'pick guitar acoustic set album and song'
      @guitar_question = quiz&.questions.find_by(content: @guitar_question_content)

      @guitar_mashup_predictions = self.mashup_answers.where(question_id: @guitar_question.id)

      return if @guitar_mashup_predictions.nil?

      @guitar_correct_mashups = @guitar_question.mashup_answers.where(response_id: nil, correct: true)

      return if @guitar_correct_mashups.nil?

      @guitar_correct_albums = @guitar_correct_mashups.pluck(:album_id)
      @guitar_correct_songs = @guitar_correct_mashups.pluck(:song_id)

      @guitar_points = mashup_max_score(@guitar_mashup_number_choice&.content)

      @guitar_mashup_predictions.each do |mashup|

        if @guitar_correct_albums.include?(mashup.album_id)
          gm_score += @guitar_points
        end

        if @guitar_correct_songs.include?(mashup.song_id)
          gm_score += @guitar_points
        end
      end

    end

    gm_score
  end

  def mixup_mashup_score
    mm_score = 0

   return if @guitar_mashup_predictions.nil? || @piano_mashup_predictions.nil?
   return if @piano_correct_songs.nil? || @guitar_correct_songs.nil?

    guitar_mashup_predictions_albums = @guitar_mashup_predictions.pluck(:album_id).uniq
    piano_mashup_predictions_albums = @piano_mashup_predictions.pluck(:album_id).uniq

    @guitar_mashup_predictions.each do |mashup|
      if @piano_correct_songs.include?(mashup.song_id)
        mm_score += @guitar_points
      else
        guitar_mashup_predictions_albums.each do |guitar_album|
          if @piano_correct_albums.include?(guitar_album)
            mm_score += 1
          end
        end
      end
    end

    @piano_mashup_predictions.each do |mashup|
      if @guitar_correct_songs.include?(mashup.song_id)
        mm_score += @piano_points
      else
        piano_mashup_predictions_albums.each do |guitar_album|
          if @guitar_correct_albums.include?(guitar_album)
            mm_score += 1
          end
        end
      end
    end

    mm_score
  end

  private

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

end