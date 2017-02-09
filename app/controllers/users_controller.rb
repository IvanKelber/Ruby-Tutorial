class UsersController < ApplicationController

  def signup
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end
end
