class SetlistsSongsController < ApplicationController

  before_action :find_setlist
  before_action :find_setlist_song, except: %i[create]


  def create
    @setlist_song = @setlist.setlist_songs.new(setlist_song_params)

    respond_to do |format|
      if @setlist_song.save
        format.html { redirect_to setlist_path(@setlist), notice: "Setlist Song was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @setlist_song.update(setlist_song_params)
        format.html { redirect_to setlist_path(@setlist), notice: "Setlist Song was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @setlist_song.destroy!

    respond_to do |format|
      format.html { redirect_to setlist_path(@setlist), notice: "Song was successfully removed from setlist." }
      format.json { head :no_content }
    end
  end

  private

  def find_setlist
    @setlist = Setlist.find(params[:setlist_id])
  end

  def find_setlist_song
    @setlist_song = SetlistSong.find(params[:id])
  end


  def setlist_song_params
    params.permit(:song_id, :era, :length)
  end
end