include ActionView::Helpers::DateHelper
include ActionView::Helpers::TextHelper

class UsersController < ApplicationController
  before_action :authorized, except: [:login, :create]
  before_action :set_user, only: %i[show update destroy]
  def index
    @users = User.all
    render json: transform_users(@users)
  end

  def show
    render json: transform_user(@user)
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid username or password' }
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  # def follow
  #   @user = User.find(params[:format])
  #   current_user.followings << @user
  # end

  # def unfollow
  #   @user = User.find(params[:format])
  #   @unfollow = Follow.where(follower_id: current_user.id, followed_user_id: @user.id).first
  #   @unfollow.destroy
  # end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:username, :password, :email)
  end

  def transform_users(users)
    new_users = []
    users.each do |user|
      new_users << { articles: user.articles, followers: user.followers, followings: user.followings,
                     user: user, createdAt: time_ago_in_words(user.created_at),
                     updatedAt: time_ago_in_words(user.updated_at),
                     articleCount: pluralize(user.articles.count, 'article') }
    end
    return new_users
  end

  def transform_user(user)
    new_user = []
    new_user << { articles: user.articles, followers: user.followers, followings: user.followings,
                  user: user, createdAt: time_ago_in_words(user.created_at),
                  updatedAt: time_ago_in_words(user.updated_at),
                  articleCount: pluralize(user.articles.count, 'article') }
    return new_user
  end
end
