class Api::TasksController < ApiController
  before_action :check_admin!
  before_action :set_task, only: [:show, :update]

  def index
    @tasks = Task.all.order(created_at: :desc)

    render 'api/tasks/index', locals: {
      tasks: @tasks
    }
  end

  def show
    render 'api/tasks/show', locals: {
      task: @task
    }
  end

  def create
    @task = Task.new(create_params)

    if @task.save
      render 'api/tasks/show', locals: {
        task: @task
      }
    else
      render json: {
        errors: @task.errors
      }
    end
  end

  def update
    if @task.update(create_params)
      render 'api/tasks/show', locals: {
        task: @task
      }
    else
      render json: {
        errors: @task.errors
      }
    end
  end

  private

  def create_params =
    params.require(:task).permit(:name)

  def set_task =
    @task = Task.find(params[:id])
end