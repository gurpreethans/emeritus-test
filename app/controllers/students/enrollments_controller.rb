# frozen_string_literal: true

module Students
  class EnrollmentsController < ApplicationController
    before_action :authorized_student!
    before_action :load_course
    before_action :load_batch

    def index
      @enrollments = @batch.enrollments.includes(:user).all
      respond_to do |format|
        format.html
        format.json { render json: MultiJson.dump(EnrollmentPresenter.list(@enrollments)), status: :ok }
      end
    end

    def enroll
      EnrollStudents.call(@batch, { student_ids: [current_user.id] })
      respond_to do |format|
        message = 'Enrollment request was successfully submitted.'
        format.html { redirect_to students_course_batch_enrollments_path(@course, @batch), notice: message }
        format.json { render json: { message: message }, status: :ok }
      end
    end

    def disenroll
      Enrollment.delete_by(user_id: current_user.id, batch_id: @batch.id)

      respond_to do |format|
        message = 'Enrollment request was successfully destroyed.'
        format.html { redirect_to students_course_batch_enrollments_path(@course, @batch), notice: message }
        format.json { render json: { message: message }, status: :ok }
      end
    end

    private

    def load_course
      @course = current_school.courses.find_by(id: params[:course_id])
    end

    def load_batch
      @batch = @course.batches.find_by(id: params[:batch_id])
    end

    def authorized_student!
      return if current_user.student?

      redirect_to root_path
    end
  end
end
