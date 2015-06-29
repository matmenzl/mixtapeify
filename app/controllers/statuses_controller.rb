class StatusesController < ApplicationController
  before_action :auth_user, only: [:show, :new,:edit,:update, :destroy]
  before_action :rspotify_authenticate, only: [:new, :edit, :create, :show, :follow]
  before_action :set_status, only: [:show, :edit, :update, :destroy]
  before_action :set_spotihunt_user, only: [:show, :new, :edit, :follow]

  # GET /statuses
  # GET /statuses.json
  def index
    authenticate_user! if params[:page]
    @statuses = Status.all.paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    # rspotify_authenticate
    # @spotihunt_user = RSpotify::User.find("wizzler")
  end

  # GET /statuses/new
  def new
    @status = current_user.statuses.new
    @playlists = @spotihunt_user.playlists.map{ |p| [p.name, p.id] if p.owner.id == current_user.uid }.compact
  end

  # GET /statuses/1/edit
  def edit
    @playlists = @spotihunt_user.playlists.map{ |p| [p.name, p.id] }
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = current_user.statuses.new(status_params)
    if params[:borrowed_playlist].empty?
      @status.image = RSpotify::Playlist.find(current_user.uid, @status.playlist).images.first["url"]
      # @status.image = RSpotify::Playlist.find("wizzler", @status.playlist).images.first["url"]
    else
      playlist_attrs = URI(params[:borrowed_playlist]).path.split("/")
      @status.spotify_uid, @status.playlist = playlist_attrs[2], playlist_attrs[4]
      @status.image = RSpotify::Playlist.find(@status.spotify_uid, @status.playlist).images.first["url"]
    end

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
    flash[:notice] = "Thanks! Every little counts!"
  end

  def follow
    @status = Status.find(params[:status_id])

    playlist = RSpotify::Playlist.find(@status.user.try(:uid), @status.playlist)
    # playlist = RSpotify::Playlist.find('wizzler', @status.playlist)

    @spotihunt_user.follow(playlist)

    flash[:notice] = "You've just followed '#{playlist.name}' playlist!"
    redirect_to @status
  end

  def share
    PlaylistsMailer.share(current_user, params[:data], params[:id]).deliver
    render nothing: true
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

    def set_spotihunt_user
      @spotihunt_user = RSpotify::User.new(current_user.spotify_user)
    end

    def auth_user
      unless user_signed_in?
        flash[:warning] = "You have to sign in with your spotify account first."
        redirect_to statuses_path
      end
    end
end
