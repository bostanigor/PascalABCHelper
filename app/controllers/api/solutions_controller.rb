class Api::SolutionsController < ApiController
  before_action :check_admin!
  before_action :set_solution, only: [:show, :update]

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
    @solution = Solution.new(create_params)

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

  def update
    if @solution.update(create_params)
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

  def create_params =
    params.require(:solution).permit(
      :student_id, :task_id, :is_successfull
    )

  def index_params
    params.permit(
      :student_id,
      :task_id,
      :page,
      :per_page,
      sort: [
        :col,
        :dir
      ]
    )
  end

  def set_solution =
    @solution = Solution.find(params[:id])
end