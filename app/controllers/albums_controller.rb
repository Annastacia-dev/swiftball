class AlbumsController < ApplicationController

  before_action :find_album, only: %i[show update destroy edit update]

  def index
    @albums = Album.active.order(:created_at)
    @album = Album.new
    @inactive_albums = Album.where(status: :inactive).order(:created_at)

    respond_to do |format|
      format.html { render :index }
      format.json {render json: @albums }
    end
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

  def update
    respond_to do |format|
      if @album.save
        format.html { redirect_to album_path(@album), notice: "Album was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html { render :show }
      format.json {render json: @album }
    end
  end

  def update
    path = request.referrer ? request.referrer : albums_path
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to path, notice: "Album was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

  def find_album
    @album = Album.friendly.find(params[:id])
  end

  def album_params
    params.require(:album).permit(:title, :status, :abbr)
  end
end