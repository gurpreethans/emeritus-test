# frozen_string_literal: true

class SchoolsController < ApplicationController
  before_action :authorized_admin!
  before_action :find_school, only: %i[edit show update destroy]
  before_action :set_school, only: %i[new create]

  def index
    @schools = School.all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(SchoolPresenter.list(@schools)), status: :ok }
    end
  end

  def new; end

  def edit; end

  def create
    form = SchoolForm.new(@school, school_params)
    respond_to do |format|
      if form.valid?
        @school = CreateSchool.call(form.attributes).school
        format.html { redirect_to schools_path, notice: 'School was successfully created.' }
        format.json { render json: MultiJson.dump(SchoolPresenter.single(@school)), status: :created }
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
    form = SchoolForm.new(@school, school_params)
    respond_to do |format|
      if form.valid?
        @school = UpdateSchool.call(@school, form.attributes).school
        format.html { redirect_to schools_path, notice: 'School was successfully updated.' }
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

  def destroy
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_path, notice: 'School was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_school
    @school = School.new
  end

  def find_school
    @school = School.find(params[:id])
  end

  def school_params
    params.require(:school).permit(:name, :description)
  end

  def authorized_admin!
    return if current_user.admin?

    redirect_to root_path
  end
end
