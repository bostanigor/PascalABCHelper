class Api::SolutionsController < ApiController
  load_and_authorize_resource

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @solutions = @solutions.includes(:student, :task)
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
    render 'api/solutions/show', locals: {
      solution: @solution
    }
  end

  private

  def create_params
    params.require(:solution).permit(:ref, :status, :code_text)
  end

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

  def sort_params
    index_params[:sort].to_h.reverse_merge(col: :created_at, dir: :desc)
  end

  def set_solution =
    @solution = Solution.find(params[:id])
end