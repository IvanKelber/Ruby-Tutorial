class UsersController < ApplicationController

  def signup
  end

  def show
    @user = User.find(params[:id])
  end
end
