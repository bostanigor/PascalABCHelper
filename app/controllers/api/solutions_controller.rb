class Api::SolutionsController < ApiController
  before_action :set_solution, only: [:show]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @solutions = Solution.includes(:student, :task)
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @solutions.page(params[:page]).per(params[:per_page] || 20) :
      @solutions.all.page(0)

    render 'api/solutions/index', locals: {
      solutions: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    if !current_user.is_admin && @solution.student != current_user.student
      render json: { error: t("auth.not_authorized")}, code: 500 and return
    end

    render 'api/solutions/show', locals: {
      solution: @solution
    }
  end



  private

  def create_params
    params.require(:solution).permit(:ref, :status, :code_text)
  end

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
    t.merge!(student_id: current_user.student.id) if !current_user.is_admin
    t
  end

  def sort_params
    index_params[:sort].to_h.reverse_merge(col: :created_at, dir: :desc)
  end

  def set_solution =
    @solution = Solution.find(params[:id])
end