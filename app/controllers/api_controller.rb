class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_user!

  def meta_attributes(collection, extra_meta = {})
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page, # use collection.previous_page when using will_paginate
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }.merge(extra_meta)
  end

  private

  def check_admin!
    render json: { error: "Current user is not admin" }, status: 401 unless current_user.is_admin
  end

  def check_student!
    @student = Student.find_by(user: current_user)
    render json: { error: "Current user is not student" }, status: 401 unless @student.present?
  end

  def set_default_format
    request.format = :json
  end
end