class CloseQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] CloseQuiz called'

    find_live_quizzes
    find_quizzes_to_close
    close_quizzes
  end

  private

  def find_live_quizzes
    return if Tour.count.zero?

    logger.info 'Finding live tours/quiz'

    @live_quizzes = Tour.where(status: :live)

    if @live_quizzes.present?
      logger.info "Found #{@live_quizzes.size} live quizzes"
    else
      logger.info 'No live quizzes found'
    end
  end

  def find_quizzes_to_close
    return if @live_quizzes.blank?

    logger.info 'Finding quizzes to close'

    @quizzes_to_close = @live_quizzes.select do |quiz|
      close_time = quiz.quiz_close_time

      logger.info "#{quiz.title} close time: #{close_time.strftime("%A %d %B %Y %H:%M")}"

      close_time <= Time.now
    end

    if @quizzes_to_close.present?
      logger.info "Found #{@quizzes_to_close.size} quizzes to close"
    else
      logger.info "No quizzes to close"
    end
  end

  def close_quizzes
    return if @quizzes_to_close.blank?

    logger.info "Closing quizzes"

    @quizzes_to_close.each do |quiz|
      quiz.update!(status: :closed)
      logger.info "Closed quiz: #{quiz.title}"
    end
  end
end