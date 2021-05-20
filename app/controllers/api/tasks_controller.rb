class Api::TasksController < ApiController
  before_action :check_admin!

  def index
    @tasks = Task.all
    render json: {
      data: @tasks
    }
  end
end