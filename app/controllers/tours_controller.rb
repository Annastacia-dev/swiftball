class ToursController < ApplicationController
  before_action :set_tour, except: %i[index new create ]
  before_action :authenticate_admin!, only: %i[show new create edit update destroy]

  # GET /tours or /tours.json
  def index
    respond_to do |format|
      if current_user.admin?
        if params[:query].present?
          @tours = Tour.search(params[:query])
                       .includes(:quiz)
                       .order(start_time: :desc)
                       .paginate(page: params[:page], per_page: 20)
        else
          @tours = Tour.includes(:quiz)
                       .order(start_time: :desc)
                       .paginate(page: params[:page], per_page: 20)
        end

        @tours_size = Tour.where.not(base: true)
                          .where.not(status: [:cancelled])
                          .size

        @quizzes = Tour.order(number: :desc)
                       .where.not(base: true)

        @users = User.order(created_at: :desc)
                     .where.not(role: 'admin')

        format.html { render :dashboard}
      else
        if params[:query].present?
          @tours = Tour.search(params[:query])
                       .order(start_time: :desc)
                       .where.not(base: true)
                       .where.not(status: [:pending])
                       .includes(:quiz)
                       .paginate(page: params[:page], per_page: 20)
        else
          @tours = Tour.order(start_time: :desc)
                       .where.not(base: true)
                       .where.not(status: [:pending])
                       .includes(:quiz)
                       .paginate(page: params[:page], per_page: 20)
        end
        @attempts = current_user.attempts
        format.html { render :user_dashboard}
      end
    end
  end

  # GET /tours/1 or /tours/1.json
  def show
    @attempts = @tour.attempts
                     .sort_by { |attempt|
                       primary_sort = @tour.closed? ? (attempt.final_position || Float::INFINITY) : -attempt.score
                       [primary_sort, attempt.created_at]
                      }
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours or /tours.json
  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to tours_path, notice: "Tour was successfully created." }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1 or /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to tours_path, notice: "Tour was successfully updated." }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1 or /tours/1.json
  def destroy
    @tour.destroy!
    respond_to do |format|
      format.html { redirect_to tours_url, notice: "Tour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def copy
    new_tour = @tour.dup
    new_tour.title = "#{@tour.title} copy"
    new_tour.number = @tour.number + 1
    new_tour.start_time = @tour.start_time + 1.day

    respond_to do |format|
      if new_tour.save(validate: false)
        duplicate_tour_quiz(@tour&.quiz, new_tour)
        format.html { redirect_to tours_path, notice: "Tour was successfully copied." }
      else
        format.html { redirect_to tours_path, alert: "Something went wrong, try again!" }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:number, :title, :start_time, :end_time, :timezone, :era_order, :preapp, :city_image, :status, opener_ids: [])
    end

    def duplicate_tour_quiz(original_quiz, new_tour)
      dupe = original_quiz.dup
      dupe.tour_id = new_tour.id
      dupe.save!
      original_quiz&.questions.each do |original_question|
        new_question = original_question.dup
        new_question.quiz_id = dupe.id
        new_question.save!

        original_question.choices.each do |original_choice|
          new_choice = original_choice.dup
          new_choice.question_id = new_question.id
          new_choice.correct = false
          new_choice.save!

          if original_choice.image.attached?
            new_choice.image.attach(original_choice.image.blob)
          end
        end
      end
      dupe
    end
end
