class Api::AttemptsController < ApiController
  before_action :check_student!, only: [:create]
  before_action :set_attempt, only: [:show]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @attempts = Attempt.includes(solution: [:task, :student])
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @attempts.page(params[:page]).per(params[:per_page] || 20) :
      @attempts.all.page(0)

    render 'api/attempts/index', locals: {
      attempts: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    render 'api/attempts/show', locals: {
      attempt: @attempt
    }
  end

  def create
    @task = Task.find_by(name: create_params[:name])
    render json: { error: t("tasks.not_found") }, status: 401 and return unless @task.present?


    @solution = @task.solutions.find_by(student: @student) ||
      Solution.new(task: @task, student: @student)
    @attempt = Attempt.new(create_params.except(:name))
    @attempt.solution = @solution

    if @attempt.save
      render 'api/solutions/show', locals: {
        solution: @solution
      }
    else
      render json: {
        errors: @solution.errors
      }
    end
  end

  private

  def create_params
    params.permit(:name, :status, :code_text)
  end

  def index_params
    t = params.permit(
      :solution_id,
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

  def set_attempt =
    @attempt = Attempt.find(params[:id])
end