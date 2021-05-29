class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      render json: { data: { token: JsonWebToken.encode(sub: user.id) } }
    else
      render json: { error: t('auth.failed') }, status: 401
    end
  end

  def fetch
    @student = current_user.student
    render 'api/authentication/fetch', locals: {
      user: current_user,
      student: @student
    }
  end

  def update_password
    if current_user&.valid_password?(params[:old_password])
      current_user.update(password: params[:new_password])
      render json: { message: t('auth.password_changed')}, status: 200
    else
      render json: { error: t('auth.wrong_password') }, status: 401
    end
  end
end