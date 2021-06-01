class Api::TasksController < ApiController
  before_action :check_admin!, only: [:create, :update]
  before_action :set_task, only: [:show, :update, :destroy]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @tasks = Task.order(created_at: :desc)
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @tasks.page(params[:page]).per(params[:per_page] || 20) :
      @tasks.all.page(0)

    render 'api/tasks/index', locals: {
      tasks: paginated,
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

  def destroy
    if @task.destroy
      render json: {
        data: { message: t('tasks.deleted')}
      }
    else
      render json: {
        data: { errors: @task.errors }
      }
    end
  end

  private

  def index_params
    params.permit(
      :name,
      :page,
      :per_page,
      sort: [
        :col,
        :dir
      ]
    )
  end

  def sort_params
    index_params[:sort].to_h.reverse_merge(col: :created_at, dir: :desc)
  end

  def create_params =
    params.require(:task).permit(:name, :description)

  def set_task =
    @task = Task.find(params[:id])
end