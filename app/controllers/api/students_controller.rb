class Api::StudentsController < ApplicationController
  before_action :check_admin!

  def index
    @students = Student.includes(:user).all
  end
end