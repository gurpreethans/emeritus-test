# frozen_string_literal: true

class BatchesController < ApplicationController
  before_action :authorized_school_admin!
  before_action :load_school
  before_action :load_course
  before_action :load_batch, only: %i[edit update destroy enrollments]
  before_action :set_batch, only: %i[new create]

  def index
    @batches = @course.batches.all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(BatchPresenter.list(@batches)), status: :ok }
    end
  end

  def new; end

  def edit; end

  def create
    form = BatchForm.new(@batch, batch_params)
    respond_to do |format|
      if form.valid?
        @batch = CreateBatch.call(@course, form.attributes).batch
        format.html { redirect_to my_school_course_batches_path, notice: 'Batch was successfully created.' }
        format.json { render json: MultiJson.dump(BatchPresenter.single(@batch)), status: :created }
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
    form = BatchForm.new(@batch, batch_params)
    respond_to do |format|
      if form.valid?
        @batch = UpdateBatch.call(@batch, form.attributes).batch
        format.html { redirect_to my_school_course_batches_path, notice: 'Batch was successfully updated.' }
        format.json { render json: MultiJson.dump(BatchPresenter.single(@batch)), status: :ok }
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
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to my_school_course_batches_path, notice: 'Batch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def load_batch
    @batch = @course.batches.find(params[:id])
  end

  def load_school
    @school = School.find params[:my_school_id]
  end

  def load_course
    @course = @school.courses.find params[:course_id]
  end

  def set_batch
    @batch = @course.batches.new
  end

  def batch_params
    params.require(:batch).permit(:name)
  end

  def authorized_school_admin!
    return if current_user.admin? || (current_user.school_admin? && SchoolAdmin.valid_admin(current_user.id,
                                                                                            params[:my_school_id]))

    redirect_to root_path
  end
end
