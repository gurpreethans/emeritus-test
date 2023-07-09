# frozen_string_literal: true

module Students
  class EnrollmentsController < ApplicationController
    before_action :authorized_student!
    before_action :load_course
    before_action :load_batch
    before_action :set_enrollment, only: %i[new create]
    before_action :load_enrollment, only: %i[destroy update_status]

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

    def create
      EnrollStudents.call(@batch, enrollment_params, status: Enrollment::APPROVED)
      respond_to do |format|
        message = 'Students were successfully enrolled.'
        format.html { redirect_to my_school_course_batch_enrollments_path, notice: message }
        format.json { render json: { message: message }, status: :created }
      end
    end

    def destroy
      @enrollment.destroy

      respond_to do |format|
        format.html do
          redirect_to my_school_course_batch_enrollments_path, notice: 'Enrollment was successfully destroyed.'
        end
        format.json { head :no_content }
      end
    end

    def update_status
      @enrollment.update!(status: params[:status])

      respond_to do |format|
        format.html do
          redirect_to my_school_course_batch_enrollments_path, notice: 'Enrollment was successfully destroyed.'
        end
        format.json { head :no_content }
      end
    end

    private

    def load_course
      @course = current_school.courses.find_by(id: params[:course_id])
    end

    def load_batch
      @batch = @course.batches.find_by(id: params[:batch_id])
    end

    def set_enrollment
      @enrollment = Enrollment.new
    end

    def authorized_student!
      return if current_user.student?

      redirect_to root_path
    end
  end
end
