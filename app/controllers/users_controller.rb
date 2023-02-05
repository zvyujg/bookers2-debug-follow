class UsersController < ApplicationController
  

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
    @books =Book.all
    @user = current_user
  end

  def edit
    @user =User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to user_path(current_user)
    end
  end
  
  # 自分がフォローしているユーザー一覧
  def following
    @user = User.find(params[:user_id])
    @followings = @user.following_user.where.not(id: current_user.id)
  end

  # 自分をフォローしているユーザー一覧
  def follower
    @user = User.find(params[:user_id])
    @followers = @user.follower_user.where.not(id: current_user.id)
  end

  def update
    @user=User.find(params[:id])
    @user.id =current_user.id
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
