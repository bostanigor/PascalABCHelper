class Api::SettingsController < ApiController
  before_action :check_admin!

  def index
    @settings = Setting.instance

    render 'api/settings/index', locals: {
      settings: @settings
    }
  end

  def update
    if Setting.instance.update(update_params)
      render 'api/settings/index', locals: {
        settings: @settings
      }
    else
      render json: {
        errors: @settings.errors
      }
    end
  end

  private

  def update_params
    params.require(:settings).permit(
      :code_text_limit,
      :retry_interval
    )
  end
end