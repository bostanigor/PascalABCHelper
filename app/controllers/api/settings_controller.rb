class Api::SettingsController < ApiController
  authorize_resource

  def show
    @settings = Setting.instance

    render 'api/settings/show', locals: {
      settings: @settings
    }
  end

  def update
    @settings = Setting.instance
    if @settings.update(update_params)
      render 'api/settings/show', locals: {
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