# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :authorized_school_admin!
  before_action :load_school
  before_action :load_course, only: %i[edit update destroy]
  before_action :set_course, only: %i[new create]

  def index
    @courses = @school.courses.all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(CoursePresenter.list(@courses)), status: :ok }
    end
  end

  def new; end

  def edit; end

  def create
    form = CourseForm.new(@course, course_params)
    respond_to do |format|
      if form.valid?
        @course = CreateCourse.call(@school, form.attributes).course
        format.html { redirect_to my_school_courses_path, notice: 'Course was successfully created.' }
        format.json { render json: MultiJson.dump(CoursePresenter.single(@course)), status: :created }
      else
        format.html do
          flash[:error] = form.errors.full_messages.join('<br/>').html_safe
          render :new, status: :unprocessable_entity
        end
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    form = CourseForm.new(@course, course_params)
    respond_to do |format|
      if form.valid?
        @course = UpdateCourse.call(@course, form.attributes).course
        format.html { redirect_to my_school_courses_path, notice: 'Course was successfully updated.' }
        format.json { render json: MultiJson.dump(CoursePresenter.single(@course)), status: :ok }
      else
        format.html do
          flash[:error] = form.errors.full_messages.join('<br/>').html_safe
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to my_school_courses_path, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def load_course
    @course = @school.courses.find(params[:id])
  end

  def load_school
    @school = School.find params[:my_school_id]
  end

  def set_course
    @course = @school.courses.new
  end

  def course_params
    params.require(:course).permit(:name, :description)
  end

  def authorized_school_admin!
    return if current_user.admin? || (current_user.school_admin? && SchoolAdmin.valid_admin(current_user.id,
                                                                                            params[:my_school_id]))

    redirect_to root_path
  end
end
