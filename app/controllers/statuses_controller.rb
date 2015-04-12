class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: :index

  # GET /statuses
  # GET /statuses.json
  def index
    authenticate_user! if params[:page]
    rspotify_authenticate

    @statuses = Status.all.paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    rspotify_authenticate
    @spotify_user = RSpotify::User.find(@status.user.try(:uid))
    # @spotify_user = RSpotify::User.find("wizzler")
  end

  # GET /statuses/new
  def new
    @status = current_user.statuses.new
    rspotify_authenticate
    spotify_user = RSpotify::User.find(current_user.uid)
    @playlists = spotify_user.playlists.map{ |p| [p.name, p.id] }
  end

  # GET /statuses/1/edit
  def edit
    rspotify_authenticate
    spotify_user = RSpotify::User.find(current_user.uid)
    @playlists = spotify_user.playlists.map{ |p| [p.name, p.id] }
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)
    @status.image = RSpotify::Playlist.find(current_user.uid, @status.playlist).images.first["url"]
    # @status.image = RSpotify::Playlist.find("wizzler", @status.playlist).images.first["url"]

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to @status, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vote
    @status = Status.find(params[:status_id])
    params[:dir] == "up" ? current_user.likes(@status) : current_user.dislikes(@status)
  end

  def follow
    @status = Status.find(params[:status_id])

    rspotify_authenticate
    spotify_user = RSpotify::User.find(current_user.uid)
    playlist = RSpotify::Playlist.find(@status.user.uid, @status.playlist)
    # playlist = RSpotify::Playlist.find('wizzler', @status.playlist)
    spotify_user.follow(playlist)

    redirect_to @status
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_params
      params.require(:status).permit(:name, :content, :playlist)
    end
end
