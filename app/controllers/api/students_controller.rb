class Api::StudentsController < ApiController
  before_action :check_admin!
  before_action :set_student, only: [:show, :update]

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @students = Student.includes(:user, :group)
      .sort_query(sort_params)
      .where(index_params.except(*META_PARAMS))

    paginated = params[:page].present? ?
      @students.page(params[:page]).per(params[:per_page] || 20) :
      @students.all


    render 'api/students/index', locals: {
      students: paginated,
      meta: meta_attributes(paginated)
    }
  end

  def show
    render 'api/students/show', locals: {
      student: @student
    }
  end

  def create
    @student = Student.new(create_params)
    if @student.save
      render 'api/students/show', locals: {
        student: @student
      }
    else
      render json: {
        errors: @student.errors
      }
    end
  end

  def update
    @user = @student.user

    @student.assign_attributes(create_params.except(:user_attributes))
    @user.assign_attributes(create_params[:user_attributes] || {})
    if @student.valid? && @user.valid?
      @student.save && @user.save
      render 'api/students/show', locals: {
        student: @student
      }
    else
      byebug
      render json: {
        errors: @student.errors
      }
    end
  end

  private

  def create_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :birthdate,
      :group_id,
      user_attributes: [
        :email,
        :password,
      ]
    )
  end

  def index_params
    params.permit(
      :group_id,
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

  def set_student =
    @student = Student.find(params[:id])
end