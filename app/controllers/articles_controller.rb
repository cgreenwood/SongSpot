# Article controller used for viewing,editing,deleting and creating articles.
class ArticlesController < ApplicationController
  def new
    if current_user && current_user.admin?
      @article = Article.new
    else
      redirect_to root_path
    end
  end

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    if current_user && current_user.admin?
      @article = Article.new(article_params)
      @article.user = current_user
      if @article.save
        redirect_to root_path
      else
        render 'new'
      end
    else
      redirect_to root_path
    end
  end

  def update
    if current_user && current_user.admin?
      @article = Article.find(params[:id])
      if @article.update(article_params)
        redirect_to root_path
      else
        render 'edit'
      end
    else
      redirect_to root_path
    end
  end

  def edit
    if current_user && current_user.admin?
      @article = Article.find(params[:id])
        render 'edit'
      else
        redirect_to root_path
      end
  end

  def destroy
    if current_user && current_user.admin?
      @article = Article.find(params[:id])
      @article.destroy
      redirect_to root_path
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
