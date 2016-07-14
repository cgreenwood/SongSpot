class BugsController < ApplicationController
  def new
    @bug = Bug.new
  end

  def index
    @bugs = Bug.all
  end

  def show
    @bug = Bug.find(params[:id])
  end

  def create
    @bug = Bug.new(article_params)
    @bug.user = current_user
    if @article.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :type, :content)
  end
end
