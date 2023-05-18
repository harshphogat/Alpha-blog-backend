include ActionView::Helpers::DateHelper

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show update destroy]
  before_action :authorized

  # GET /articles
  def index
    @articles = Article.all
    render json: transform_articles(@articles)
  end

  # GET /articles/1
  def show
    render json: transform_article(@article)
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.user = @user
    @article.categories << Category.find(params[:category]) if params[:category]

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      new_category = Category.find(params[:category])
      @article.categories.clear
      @article.categories << new_category
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :description, :user_id)
  end

  def transform_articles(articles)
    new_articles = []
    articles.each do |article|
      new_articles << { article: article, categories: article.categories,
                        user: article.user, createdAt: time_ago_in_words(article.created_at),
                        updatedAt: time_ago_in_words(article.updated_at)}
    end
    return new_articles
  end

  def transform_article(article)
    new_article = []
    new_article << { article: article, categories: article.categories,
                     user: article.user, createdAt: time_ago_in_words(article.created_at),
                     updatedAt: time_ago_in_words(article.updated_at)}
    return new_article
  end
end
