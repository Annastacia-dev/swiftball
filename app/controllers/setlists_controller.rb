class SetlistsController < ApplicationController

  before_action :find_setlist, except: %i[index new create]

  def index
    @setlists = Setlist.where(tour_id: nil)
  end

  def new
    @setlist = Setlist.new
  end

  def show
    @songs = @setlist.setlist_songs.includes(:song).group_by(&:era)
  end

  def create
    @setlist = Setlist.new(setlist_params)

    respond_to do |format|
      if @setlist.save
        format.html { redirect_to setlists_path, notice: "Setlist was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @setlist.update(setlist_params)
        format.html { redirect_to setlist_path(@setlist), notice: "Setlist was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_setlist
    @setlist = Setlist.find(params[:id])
  end

  def setlist_params
    params.require(:setlist).permit(:tour_id, :league, :status)
  end
end