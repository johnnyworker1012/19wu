class AdminController < ApplicationController
  prepend_before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end
  
end
