class UsersController < ApplicationController

  respond_to :json

  def index
    @users = User.all
    respond_with @users
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      respond_with @user
    else
      render_object_errors(@user)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      head :no_content
    else
      render_object_errors(@user)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end
end
