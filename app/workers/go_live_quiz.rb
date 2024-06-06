class GoLiveQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] GoLiveQuiz called'

    find_open_quizzes
    find_quizzes_to_go_live
    live_quizzes
  end

  private

  def find_open_quizzes
    return if Tour.count.zero?

    logger.info 'Finding open tours/quiz'

    @open_quizzes = Tour.where(status: :open)

    if @open_quizzes.present?
      logger.info "Found #{@open_quizzes.size} open quizzes"
    else
      logger.info 'No open quizzes found'
    end
  end

  def find_quizzes_to_go_live
    return if @open_quizzes.blank?

    logger.info 'Finding quizzes to go live'

    @quizzes_to_go_live = @open_quizzes.select do |quiz|
      live_time = quiz.quiz_live_time

      logger.info "#{quiz.title} live time: #{live_time.strftime("%A %d %B %Y %H:%M")}"

      live_time <= Time.now
    end

    if @quizzes_to_go_live.present?
      logger.info "Found #{@quizzes_to_go_live.size} quizzes to go live"
    else
      logger.info "No quizzes to go live"
    end
  end

  def live_quizzes
    return if @quizzes_to_go_live.blank?

    logger.info "Going live quizzes"

    @quizzes_to_go_live.each do |quiz|
      quiz.update!(status: :live)
      logger.info "Live quiz: #{quiz.title}"
    end
  end
end