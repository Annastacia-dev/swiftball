module StatisticsHelper
  def responses_table_data(responses)
    table_data = {}

    responses.each do |response|
      question = response.question.text
      tour = response.attempt.quiz.tour.name
      participant = response.attempt.user.name
      result = response.predicted_correctly? ? 'correct' : 'wrong'

      table_data[question] ||= {}
      table_data[question][tour] ||= {}
      table_data[question][tour][participant] = result
    end

    table_data
  end
end