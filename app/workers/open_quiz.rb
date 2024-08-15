class OpenQuiz
  include Sidekiq::Worker

  def perform(*args)
    logger.info  '[Worker] Open tour called'

    find_pending_tours
    find_tours_to_open
    open_tours
  end

  private

  def find_pending_tours
    return if Tour.count.zero?

    logger.info 'Finding pending tours/tour'

    @pending_tours = Tour.where(status: :pending)

    if @pending_tours.present?
      logger.info "Found #{@pending_tours.size} pending tours"
    else
      logger.info 'No pending tours found'
    end
  end

  def find_tours_to_open
    return if @pending_tours.blank?

    logger.info 'Finding tours to open'

    @tours_to_open = @pending_tours.select do |tour|
      start_time = tour.start_time
      start_day = start_time.beginning_of_day

      logger.info "#{tour.title} start time: #{start_time.strftime("%A %d %B %Y %H:%M")}"
      logger.info "#{tour.title} start day: #{start_day.strftime("%A %d %B %Y %H:%M")}"

      start_day <= Time.now
    end

    if @tours_to_open.present?
      logger.info "Found #{@tours_to_open.size} tours to open"
    else
      logger.info "No tours to open"
    end
  end

  def open_tours
    return if @tours_to_open.blank?

    logger.info "Opening tours"

    @tours_to_open.each do |tour|
      tour.update!(status: :open)
      Quizzes::OpenPushNotification.call('quiz_id' => tour&.quiz.id)
      Quizzes::OpenEmail.call('quiz_id' => tour&.quiz.id)

      logger.info "Opened tour: #{tour.title}"
    end
  end
end