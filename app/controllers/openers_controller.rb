class OpenersController < ApplicationController

  before_action :find_opener, only: %i[update destroy edit update]

  def index
    @openers = Opener.all
    @opener = Opener.new
  end

  def create
    @opener = Opener.new(opener_params)

    respond_to do |format|
      if @opener.save
        format.html { redirect_to openers_path, notice: "Opener was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @opener.save
        format.html { redirect_to openers_path, notice: "Opener was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @opener.destroy!

    respond_to do |format|
      format.html { redirect_to openers_path, notice: "Opener was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def find_opener
    @opener = Opener.find(params[:id])
  end

  def opener_params
    params.require(:opener).permit(:name)
  end
end