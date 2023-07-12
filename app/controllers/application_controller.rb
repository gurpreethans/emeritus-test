# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authenticate_user!
  respond_to :html, :json
  helper_method :current_school

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    respond_to do |f|
      f.json do
        render json: {
          errors: { message: 'Not found' }
        }, status: :not_found
      end
    end
  end

  def after_sign_in_path_for(_resource)
    root_path
  end

  def current_school
    return unless current_user.student?

    @current_school ||= current_user.school
  end
end
