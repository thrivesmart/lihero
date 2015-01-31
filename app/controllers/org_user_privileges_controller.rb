class OrgUserPrivilegesController < ApplicationController
  before_action :set_org_user_privilege, only: [:show, :edit, :update, :destroy]

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
    @org_user_privilege = OrgUserPrivilege.new
  end

  # GET /org_user_privileges/1/edit
  def edit
  end

  # POST /org_user_privileges
  # POST /org_user_privileges.json
  def create
    @org_user_privilege = OrgUserPrivilege.new(org_user_privilege_params)

    respond_to do |format|
      if @org_user_privilege.save
        format.html { redirect_to @org_user_privilege, notice: 'Org user privilege was successfully created.' }
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
        format.html { redirect_to @org_user_privilege, notice: 'Org user privilege was successfully updated.' }
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
      format.html { redirect_to org_user_privileges_url, notice: 'Org user privilege was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_org_user_privilege
      @org_user_privilege = OrgUserPrivilege.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def org_user_privilege_params
      params.require(:org_user_privilege).permit(:organization_id, :user_id, :privileges, :creator_id)
    end
end
