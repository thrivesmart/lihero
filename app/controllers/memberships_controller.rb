class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_auth
  before_filter :set_authed_user_membership
  before_filter :enforce_can_read, only: [:index, :show]
  before_filter :enforce_can_execute, only: [:new, :create, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = @organization.memberships.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = @organization.memberships.build(creator: authed_user)
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = @organization.memberships.build(membership_params.merge(creator: authed_user))

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url, notice: 'Membership was successfully destroyed.' }
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

    def enforce_can_execute
      if !@set_authed_user_membership.execute?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = @organization.memberships.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:user_via_email, :privileges)
    end
end
