class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = Book.all
    @user_today_books = Book.where(user_id: current_user.id).where(created_at: Time.zone.now.all_day)
    @user_yesterday_books = Book.where(user_id: current_user.id).where(created_at: 1.day.ago.all_day)
    this_to = Date.today
    this_from = this_to - 1.week
    @user_thisweek_books = Book.where(user_id: current_user.id).where(created_at: this_from...this_to)
    last_to = this_from - 1.day
    last_from = last_to - 1.week
    @user_lastweek_books = Book.where(user_id: current_user.id).where(created_at: last_from...last_to)
    @new_book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
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
