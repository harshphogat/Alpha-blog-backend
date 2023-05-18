include ActionView::Helpers::DateHelper
include ActionView::Helpers::TextHelper


class CategoriesController < ApplicationController
  before_action :authorized

  # GET /categories
  def index
    @categories = Category.all
    render json: transform_categories(@categories)
  end

  # GET /categories/1
  def show
    set_category
    render json: transform_category(@category)
  end

  # # POST /articles
  # def create
  #   @article = Article.new(article_params)
  #   @article.user = @user

  #   if @article.save
  #     render json: @article, status: :created, location: @article
  #   else
  #     render json: @article.errors, status: :unprocessable_entity
  #   end
  # end

  # # PATCH/PUT /articles/1
  # def update
  #   if @article.update(article_params)
  #     render json: @article
  #   else
  #     render json: @article.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /articles/1
  # def destroy
  #   @article.destroy
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # # Only allow a list of trusted parameters through.
  # def article_params
  #   params.require(:article).permit(:title, :description, :user_id)
  # end

  def transform_categories(categories)
    new_category = []
    categories.each do |category|
      new_category << { category: category, articles: category.articles,
                        createdAt: time_ago_in_words(category.created_at),
                        updatedAt: time_ago_in_words(category.updated_at),
                        articleCount: pluralize(category.articles.count, 'article')
                      }
    end
    return new_category
  end

  def transform_category(category)
    new_category = []
    new_category << { category: category, articles: category.articles,
                      createdAt: time_ago_in_words(category.created_at),
                      updatedAt: time_ago_in_words(category.updated_at),
                      articleCount: pluralize(category.articles.count, 'article')
                    }
    return new_category
  end
end
