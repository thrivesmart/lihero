class LeadsController < ApplicationController
  before_action :set_organization
  before_action :set_list
  before_action :set_lead, only: [:show, :edit, :update, :destroy]
  before_filter :enforce_auth
  before_filter :set_authed_user_membership
  before_filter :enforce_can_read, only: [:index, :show]
  before_filter :enforce_can_write, only: [:new, :create, :edit, :update, :destroy]

  # GET /leads
  # GET /leads.json
  def index
    @leads = @list.leads.all
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
  end

  # GET /leads/new
  def new
    @lead = @list.leads.build(creator: authed_user)
  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = @list.leads.build(lead_params.merge(creator: authed_user))

    respond_to do |format|
      if @lead.save
        format.html { redirect_to [@lead.list.organization, @lead.list, @lead], notice: 'Lead was successfully created.' }
        format.json { render :show, status: :created, location: [@lead.list.organization, @lead.list, @lead] }
      else
        format.html { render :new }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to [@lead.list.organization, @lead.list, @lead], notice: 'Lead was successfully updated.' }
        format.json { render :show, status: :ok, location: [@lead.list.organization, @lead.list, @lead] }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to [@lead.list.organization, @lead.list, :leads], notice: 'Lead was successfully destroyed.' }
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
      @list = @organization.lists.find_by_permalink(params[:list_id])
      raise ActiveRecord::RecordNotFound unless @list
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = @list.leads.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:search_query, :linkedinid, :kind, :archived_at, :name, :email, :phone, :picurl, :details, :notes)
    end
end
