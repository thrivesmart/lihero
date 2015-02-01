class OrgUserPrivilegesController < ApplicationController
  before_action :set_organization
  before_action :set_org_user_privilege, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_auth
  before_filter :set_authed_user_org_user_privilege
  before_filter :enforce_can_read, only: [:index, :show]
  before_filter :enforce_can_execute, only: [:new, :create, :edit, :update, :destroy]
  
  # GET /org_user_privileges
  # GET /org_user_privileges.json
  def index
    @org_user_privileges = OrgUserPrivilege.all
  end

  # GET /org_user_privileges/1
  # GET /org_user_privileges/1.json
  def show
  end

  # GET /org_user_privileges/new
  def new
    @org_user_privilege = @organization.org_user_privileges.build(creator: authed_user)
  end

  # GET /org_user_privileges/1/edit
  def edit
  end

  # POST /org_user_privileges
  # POST /org_user_privileges.json
  def create
    @org_user_privilege = @organization.org_user_privileges.build(org_user_privilege_params.merge(creator: authed_user))

    respond_to do |format|
      if @org_user_privilege.save
        format.html { redirect_to @org_user_privilege, notice: 'Team member was successfully created.' }
        format.json { render :show, status: :created, location: @org_user_privilege }
      else
        format.html { render :new }
        format.json { render json: @org_user_privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /org_user_privileges/1
  # PATCH/PUT /org_user_privileges/1.json
  def update
    respond_to do |format|
      if @org_user_privilege.update(org_user_privilege_params)
        format.html { redirect_to @org_user_privilege, notice: 'Team member was successfully updated.' }
        format.json { render :show, status: :ok, location: @org_user_privilege }
      else
        format.html { render :edit }
        format.json { render json: @org_user_privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /org_user_privileges/1
  # DELETE /org_user_privileges/1.json
  def destroy
    @org_user_privilege.destroy
    respond_to do |format|
      format.html { redirect_to org_user_privileges_url, notice: 'Team member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = authed_user.organizations.find_by_permalink(params[:organization_id])
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

    def enforce_can_execute
      if !@set_authed_user_org_user_privilege.execute?
        render :text => "Sorry, you aren't authorized to access this page.", :status => :unauthorized
        return false
      else
        return true
      end
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_org_user_privilege
      @org_user_privilege = @organization.org_user_privileges.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def org_user_privilege_params
      params.require(:org_user_privilege).permit(:user_via_email, :privileges)
    end
end
