class AdminController < ApplicationController
  prepend_before_filter :authenticate_user!

  def index
    authorize! :index, current_user 
    @users = User.all
  end
end
