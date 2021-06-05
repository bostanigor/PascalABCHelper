class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: t('auth.not_authorized') }, status: :forbidden
  end

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

  def set_default_format
    request.format = :json
  end
end