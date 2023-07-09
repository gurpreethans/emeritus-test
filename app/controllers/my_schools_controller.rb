# frozen_string_literal: true

class MySchoolsController < ApplicationController
  before_action :authorized_school_admin!
  before_action :find_school, only: %i[edit show update destroy]
  before_action :set_school, only: %i[new create]

  def index
    @schools = current_user.schools.all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(SchoolPresenter.list(@schools)), status: :ok }
    end
  end

  def edit; end

  def update
    form = SchoolForm.new(@school, school_params)
    respond_to do |format|
      if form.valid?
        @school = UpdateSchool.call(@school, form.attributes).school
        format.html { redirect_to my_schools_path, notice: 'School was successfully updated.' }
        format.json { render json: MultiJson.dump(SchoolPresenter.single(@school)), status: :ok }
      else
        format.html do
          flash[:error] = form.errors.full_messages.join('<br/>').html_safe
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :description)
  end

  def authorized_school_admin!
    return if current_user.school_admin?

    redirect_to root_path
  end
end
