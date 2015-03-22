class LinkedinController < ApplicationController
  before_filter :enforce_auth
  
  def people
    @results = LinkedinSearch.company_connections(params[:q], authed_user.default_linkedin_oauth)

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end

  def companies
    @results = LinkedinSearch.company_search(params[:q], authed_user.default_linkedin_oauth)

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end
end
