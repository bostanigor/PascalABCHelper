class Api::StudentsController < ApiController
  before_action :check_admin!

  def index
    @students = Student.includes(:user, :group).all

    render 'api/students/index', locals: {
      students: @students
    }
  end

  def show
    @student = Student.includes(:user, :group).find(params[:id])

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
    @student = Student.find(params[:id])
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
end