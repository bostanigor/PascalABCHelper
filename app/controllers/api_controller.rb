class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_user!

  private

  def check_admin!
    render json: { error: "Current user is not admin" }, status: 401 if current_user.is_admin
  end

  def set_default_format
    request.format = :json
  end
end