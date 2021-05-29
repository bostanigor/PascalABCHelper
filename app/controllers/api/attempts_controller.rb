class Api::AttemptsController < ApiController
  before_action :check_student!, only: [:create]
  before_action :set_attempt, only: [:show]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @attempts = Attempt.includes(solution: [:task, :student])
      .order(created_at: :desc)
      .where(index_params.except(*META_PARAMS))

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
    @task = Task.find_by(create_params[:ref])
    render json: { error: t("tasks.not_found") }, status: 401 and return unless @task.present?

    @solution = @task.solutions.find_by(student: @student) ||
      Solution.new(task: @task, student: @student)
    @solution.attempts << Attempt.new(create_params.except(:ref))

    if @soluion.save
      render 'api/solutions/show', locals: {
        solution: @solution
      }
    else
      render json: {
        errors: @attempt.errors
      }
    end
  end

  private

  def create_params
    params.require(:attempts).permit(:ref, :status, :code_text)
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

  def set_attempt =
    @attempt = Attempt.find(params[:id])
end