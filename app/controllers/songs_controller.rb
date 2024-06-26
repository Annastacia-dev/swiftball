class SongsController < ApplicationController
  before_action :set_album
  before_action :set_song, only: %i[edit update destroy]

  def index
    @songs = @album.songs.all.order(:created_at)

    respond_to do |format|
      format.html { render :index }
      format.json {render json: @songs }
    end
  end

  def create
    @song = @album.songs.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to album_path(@album), notice: "Song was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to album_path(@album), notice: "Song was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @song.destroy!

    respond_to do |format|
      format.html { redirect_to album_path(@song.album), notice: "Song was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_album
    @album = Album.friendly.find(params[:album_id])
  end

  def set_song
    @song = @album.songs.find(params[:id])
  end

  def song_params
    params.require(:song).permit(:title)
  end
end