# frozen_string_literal: true

module Students
  class CoursesController < ApplicationController
    before_action :authorized_student!

    def index
      @courses = current_school.courses.all
      respond_to do |format|
        format.html
        format.json { render json: MultiJson.dump(CoursePresenter.list(@courses)), status: :ok }
      end
    end

    private

    def authorized_student!
      return if current_user.student?

      redirect_to root_path
    end
  end
end
