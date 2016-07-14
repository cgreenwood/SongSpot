# Users Controller used for displaying user pages.
class UsersController < ApplicationController
  def show
    if current_user && (User.find(params[:id]).name == current_user.name)
      @user = User.find(params[:id])
    else
      redirect_to root_path
    end
  end
end
