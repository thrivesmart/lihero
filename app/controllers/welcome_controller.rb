class WelcomeController < ApplicationController
  before_filter :enforce_auth, only: :home
  
  def index
  end
  
  def home
  end
end
