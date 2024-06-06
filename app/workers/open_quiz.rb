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

    @quizzes_to_open = @pending_quizzes.select do |quiz|
      start_time = quiz.start_time
      start_day = start_time.beginning_of_day

      logger.info "#{quiz.title} start time: #{start_time.strftime("%A %d %B %Y %H:%M")}"
      logger.info "#{quiz.title} start day: #{start_day.strftime("%A %d %B %Y %H:%M")}"

      start_day <= Time.now
    end

    if @quizzes_to_open.present?
      logger.info "Found #{@quizzes_to_open.size} quizzes to open"
    else
      logger.info "No quizzes to open"
    end
  end

  def open_quizzes
    return if @quizzes_to_open.blank?

    logger.info "Opening quizzes"

    @quizzes_to_open.each do |quiz|
      quiz.update!(status: :open)
      logger.info "Opened quiz: #{quiz.title}"
    end
  end
end