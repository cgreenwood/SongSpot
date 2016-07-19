class BugsController < ApplicationController
  def new
    @bug = Bug.new
  end

  def index
    if current_user
      @bugs = Bug.all
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @bug = Bug.find(params[:id])
  end

  def create
    @bug = Bug.new(bug_params)
    @bug.user = current_user
    if @bug.save
      redirect_to bugs_path
    else
      render 'new'
    end
  end

  def update
    if current_user && current_user.admin?
      @bug = Bug.find(params[:id])
      if @bug.update(bug_params)
        redirect_to bugs_path
      else
        render 'edit'
      end
    else
      redirect_to root_path
    end
  end

  def edit
    if current_user && current_user.admin?
      @bug = Bug.find(params[:id])
        render 'edit'
      else
        redirect_to root_path
      end
  end

  def destroy
    @bug = Bug.find(params[:id])
    @bug.destroy
    redirect_to bugs_path
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :bug_type, :content, :bug_status)
  end
end
