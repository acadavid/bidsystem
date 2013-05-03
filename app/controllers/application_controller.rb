class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def render_object_errors(object)
    render json: {errors: object.errors.full_messages.join(", ")}, status: :unprocessable_entity
  end
end
