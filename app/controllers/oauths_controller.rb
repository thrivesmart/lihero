class OauthsController < ApplicationController
  before_filter :enforce_auth
  before_action :set_oauth, only: [:show, :edit, :update, :destroy]

  # GET /oauths
  # GET /oauths.json
  def index
    @oauths = authed_user.oauths.all
  end

  # GET /oauths/1
  # GET /oauths/1.json
  def show
  end

  # GET /oauths/new
  # def new
  #   @oauth = Oauth.new
  # end

  # GET /oauths/1/edit
  def edit
  end

  # POST /oauths
  # POST /oauths.json
  # def create
  #   @oauth = Oauth.new(oauth_params)
  #
  #   respond_to do |format|
  #     if @oauth.save
  #       format.html { redirect_to @oauth, notice: 'Oauth was successfully created.' }
  #       format.json { render :show, status: :created, location: @oauth }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @oauth.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /oauths/1
  # PATCH/PUT /oauths/1.json
  # def update
  #   respond_to do |format|
  #     if @oauth.update(oauth_params)
  #       format.html { redirect_to @oauth, notice: 'Oauth was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @oauth }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @oauth.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /oauths/1
  # DELETE /oauths/1.json
  def destroy
    @oauth.destroy
    respond_to do |format|
      format.html { redirect_to user_oauths_url(authed_user), notice: 'OAuth token was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oauth
      @oauth = authed_user.oauths.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oauth_params
      params.require(:oauth).permit(:user_id, :account, :kind, :token, :secret)
    end
end
