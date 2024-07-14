class ToursController < ApplicationController
  before_action :set_tour, only: %i[show edit update destroy ]
  before_action :authenticate_admin!, only: %i[show new create edit update destroy]

  # GET /tours or /tours.json
  def index
    respond_to do |format|
      if current_user.admin?
        @tours = Tour.includes(:quiz).order(number: :desc).paginate(page: params[:page], per_page: 10)
        @quizzes = Tour.order(number: :desc).where.not(base: true)
        @users = User.order(created_at: :desc).where.not(role: 'admin')

        format.html { render :dashboard}
      else
        @tours = Tour.order(number: :desc).where.not(base: true).where(status: [:closed, :open, :live]).includes(:quiz).paginate(page: params[:page], per_page: 10)
        @attempts = current_user.attempts
        format.html { render :user_dashboard}
      end
    end
  end

  # GET /tours/1 or /tours/1.json
  def show
    @attempts = @tour.attempts
                   .sort_by do |attempt|
                     if @tour.closed?
                       attempt.final_position || Float::INFINITY
                     else
                       -attempt.score
                     end
                   end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:number, :title, :start_time, :end_time, :timezone)
    end
end
