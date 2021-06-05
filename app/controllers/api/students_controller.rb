class Api::StudentsController < ApiController
  load_and_authorize_resource

  META_PARAMS = %i(page per_page sort).freeze

  def index
    @students = @students.includes(:user, :group)
      .sort_query(sort_params)
      .filter_query(index_params.except(*META_PARAMS))

    paginated = @students.page(params[:page] || 1)
      .per(params[:per_page] || 20)

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
      render json: {
        errors: @student.errors
      }
    end
  end

  def destroy
    if @student.destroy
      render json: {
        data: { message: t('students.deleted')}
      }
    else
      render json: {
        data: { errors: @student.errors }
      }
    end
  end

  def batch_destroy
    Student.destroy(params[:ids])
  end

  private

  def create_params
    params.require(:student).permit(
      :first_name,
      :last_name,
      :birthdate,
      :group_id,
      user_attributes: [
        :username,
        :password,
      ]
    )
  end

  def index_params
    params.permit(
      :group_id,
      :first_name,
      :last_name,
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