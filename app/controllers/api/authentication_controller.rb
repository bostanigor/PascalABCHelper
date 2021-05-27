class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      render json: { data: { token: JsonWebToken.encode(sub: user.id) } }
    else
      render json: { errors: 'invalid' }, status: 401
    end
  end

  def fetch
    @student = current_user.student
    render 'api/authentication/fetch', locals: {
      user: current_user,
      student: @student
    }
  end
end