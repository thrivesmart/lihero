class ListsController < ApplicationController
  before_action :set_organization
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_auth
  before_filter :set_authed_user_membership
  before_filter :enforce_can_read, only: [:index, :show]
  before_filter :enforce_can_write, only: [:new, :create, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    @lists = @organization.lists.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = @organization.lists.build(creator: authed_user)
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = @organization.lists.build(list_params.merge(creator: authed_user))

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = authed_user.organizations.find_by_permalink(params[:organization_id])
      raise ActiveRecord::RecordNotFound unless @organization
    end

    def set_authed_user_membership
      @set_authed_user_membership = @organization.memberships.where(user_id: authed_user.id).first
      raise ActiveRecord::RecordNotFound unless @set_authed_user_membership
    end

    def enforce_can_read
      if !@set_authed_user_membership.read?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end

    def enforce_can_write
      if !@set_authed_user_membership.write?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = @organization.lists.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :permalink, :description, :picurl)
    end
end
