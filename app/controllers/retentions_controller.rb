class RetentionsController < ApplicationController 
 
  before_filter :authenticate_user!
  load_and_authorize_resource

  def show_users
  end


end
