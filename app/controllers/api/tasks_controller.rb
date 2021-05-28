class Api::TasksController < ApiController
  before_action :check_admin!, only: [:create, :update]
  before_action :set_task, only: [:show, :update]

  def index
    @tasks = Task.order(created_at: :desc)

    paginated = params[:page].present? ?
      @tasks.page(params[:page]).per(params[:per_page] || 20) :
      @tasks.all

    render 'api/tasks/index', locals: {
      tasks: @tasks,
      meta: meta_attributes(paginated)
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
    params.require(:task).permit(:name, :ref)

  def set_task =
    @task = Task.find(params[:id])
end