class Api::ProfilesController < ApiController
  before_action :check_student!

  META_PARAMS = %i(page per_page sort).freeze

  def show
    render 'api/students/show', locals: {
      student: @student
    }
  end
end