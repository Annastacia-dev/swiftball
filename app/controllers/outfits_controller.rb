class OutfitsController < ApplicationController
  before_action :authenticate_admin!, only: %i[new create edit update destroy]
  before_action :find_outfit, only: %i[edit update destroy]

  def index
    @outfits = Outfit.includes(image_attachment: :blob).all
  end

  def new
    @outfit = Outfit.new
  end

  def tracker
    labels = Choice.labels.select {|k, v| k != 'no_label'}
    @labels = labels.map { |label| label[0]}
    @outfits = Choice.includes([image_attachment: :blob])
                     .joins(:question) # Ensure you join the Question model
                     .where.not(outfit_codename: nil)
                     .order('outfit_codename, questions.era', 'position')
                     .select('DISTINCT ON (outfit_codename) choices.*')
  end

  def create
    @outfit = Outfit.new(outfit_params)

    respond_to do |format|
      if @outfit.save
        if params[:commit] == "Create Outfit & Add Another"
          format.html { redirect_to new_outfit_path, notice: "Outfit was successfully created." }
        else
          format.html { redirect_to outfits_path, notice: "Outfit was successfully created." }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outfit.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @outfit.update(outfit_params)
        format.html { redirect_to outfits_path, notice: "Outfit was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @outfit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @outfit.destroy!

    respond_to do |format|
      format.html { redirect_to outfits_path, notice: "Outfit was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def outfit_params
    params.require(:outfit).permit(:image, :era)
  end

  def find_outfit
    @outfit = Outfit.find(params[:id])
  end
end