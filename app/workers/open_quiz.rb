class OpenQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] OpenQuiz called'

    find_pending_quizzes
    find_quizzes_to_open
    open_quizzes
  end

  private

  def find_pending_quizzes
    return if Tour.count.zero?

    logger.info 'Finding pending tours/quiz'

    @pending_quizzes = Tour.where(status: :pending)

    if @pending_quizzes.present?
      logger.info "Found #{@pending_quizzes.size} pending quizzes"
    else
      logger.info 'No pending quizzes found'
    end
  end

  def find_quizzes_to_open
    return if @pending_quizzes.blank?

    logger.info 'Finding quizzes to open'

    @quizzes_to_open = @pending_quizzes.select { |quiz| quiz.start_time}
  end

  def open_quizzes
  end
end