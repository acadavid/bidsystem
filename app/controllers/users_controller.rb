class UsersController < ApplicationController

  respond_to :json

  def create
    @user = User.new(params[:user])

    if @user.save
      respond_with @user
    else
      render json: {errors: @user.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      head :no_content
    else
      render json: {errors: @user.errors.full_messages.join(", ")}, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    head :no_content
  end
end
