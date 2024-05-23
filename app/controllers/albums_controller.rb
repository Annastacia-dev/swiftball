class AlbumsController < ApplicationController

  before_action :find_album, only: %i[show update destroy]

  def index
    @albums = Album.all.order(:created_at)
    @album = Album.new
  end

  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to albums_path, notice: "Album was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def find_album
    @album = Album.friendly.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title)
  end
end