class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private
  def record_not_found(error)
    render json: error.message, status: :bad_request
  end

end
