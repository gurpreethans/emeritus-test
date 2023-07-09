# frozen_string_literal: true

class EnrollmentsController < ApplicationController
  before_action :authorized_school_admin!
  before_action :load_school
  before_action :load_course
  before_action :load_batch
  before_action :set_enrollment, only: %i[new create]
  before_action :load_enrollment, only: %i[destroy update_status]

  def index
    @enrollments = @batch.enrollments.all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(EnrollmentPresenter.list(@enrollments)), status: :ok }
    end
  end

  def new
    @students = User.left_joins(:enrollments).students.where(enrollments: { id: nil })
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(StudentPresenter.list(@students)), status: :ok }
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

  def load_school
    @school = School.find_by(id: params[:my_school_id])
  end

  def load_course
    @course = @school.courses.find_by(id: params[:course_id])
  end

  def load_batch
    @batch = @course.batches.find_by(id: params[:batch_id])
  end

  def load_enrollment
    @enrollment = @batch.enrollments.find_by(id: params[:id])
  end

  def set_enrollment
    @enrollment = Enrollment.new
  end

  def enrollment_params
    params.permit(student_ids: [])
  end

  def authorized_school_admin!
    return if current_user.admin? || (current_user.school_admin? && SchoolAdmin.valid_admin(current_user.id,
                                                                                            params[:my_school_id]))

    redirect_to root_path
  end
end
