# frozen_string_literal: true

module Students
  class BatchesController < ApplicationController
    before_action :authorized_student!
    before_action :load_course

    def index
      @batches = @course.batches.includes(:enrollments).all
      respond_to do |format|
        format.html
        format.json { render json: MultiJson.dump(BatchPresenter.list(@batches)), status: :ok }
      end
    end

    private

    def authorized_student!
      return if current_user.student?

      redirect_to root_path
    end

    def load_course
      @course = current_school.courses.find(params[:course_id])
    end
  end
end
