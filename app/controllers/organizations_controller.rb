class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_auth
  before_filter :set_authed_user_org_user_privilege, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_can_read, only: [:show]
  before_filter :enforce_can_write, only: [:edit, :update]
  before_filter :enforce_can_execute, only: [:destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = authed_user.organizations.all
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new(creator: authed_user)
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params.merge(creator: authed_user))

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = authed_user.organizations.find_by_permalink(params[:id])
      raise ActiveRecord::RecordNotFound unless @organization
    end

    def set_authed_user_org_user_privilege
      @set_authed_user_org_user_privilege = @organization.org_user_privileges.where(user_id: authed_user.id).first
      raise ActiveRecord::RecordNotFound unless @set_authed_user_org_user_privilege
    end
    
    def enforce_can_read
      if !@set_authed_user_org_user_privilege.read?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end
    
    def enforce_can_write
      if !@set_authed_user_org_user_privilege.write?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end
    
    def enforce_can_execute
      if !@set_authed_user_org_user_privilege.execute?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :permalink, :website)
    end
end
