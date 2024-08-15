module OrderQuestions
  def order_questions
    if @quiz.tour.era_order == 'new_order'
      @questions_by_era = @quiz&.questions
                               .order(:era)
                               .order(:position)
                               .group_by(&:era)
    else
      order_sql = Question.old_era_order
      @questions_by_era = @quiz&.questions
                               .order(Arel.sql("CASE era #{order_sql} END"))
                               .order(:position)
                               .group_by(&:era)
    end
  end
end