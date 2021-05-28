class Api::SolutionsController < ApiController
  before_action :check_admin!, except: [:create, :index]
  before_action :check_student!, only: [:create]
  before_action :set_solution, only: [:show]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @solutions = Solution.includes(:student, :task)
      .order(created_at: :desc)
      .where(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @solutions.page(params[:page]).per(params[:per_page] || 20) :
      @solutions.all

    render 'api/solutions/index', locals: {
      solutions: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    render 'api/solutions/show', locals: {
      solution: @solution
    }
  end

  def create
    @task = Task.find_by(ref: params[:ref])
    render json: { error: "Task is not found" }, status: 500 and return unless @task.present?

    @solution = @task.solutions.find_by(student: @student) ||
      Solution.new(task: @task, student: @student)

    @solution.assign_attributes(
      is_successfull: params[:is_successfull],
    )

    if @solution.save
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

  def index_params
    t = params.permit(
      :student_id,
      :task_id,
      :page,
      :per_page,
      sort: [
        :col,
        :dir
      ]
    )
    t.merge(student_id: current_user.student.id) if !current_user.is_admin
  end

  def set_solution =
    @solution = Solution.find(params[:id])
end