# frozen_string_literal: true

class SchoolAdminsController < ApplicationController
  before_action :authorized_admin!
  before_action :find_admin, only: %i[destroy]
  before_action :set_user, only: %i[new create]

  def index
    @admins = SchoolAdmin.includes(:school, :user).all
    respond_to do |format|
      format.html
      format.json { render json: MultiJson.dump(SchoolAdminPresenter.list(@admins)), status: :ok }
    end
  end

  def new; end

  def create
    form = SchoolAdminForm.new(@user, school_params)
    respond_to do |format|
      if form.valid?
        @user = ManageSchoolAdmin.call(form.attributes)
        format.html { redirect_to school_admins_path, notice: 'School admin was successfully created.' }
        format.json { render json: MultiJson.dump(SchoolAdminPresenter.single(@user.admin)), status: :created }
      else
        format.html do
          flash[:error] = form.errors.full_messages.join('<br/>').html_safe
          render :new, status: :unprocessable_entity
        end
        format.json { render json: form.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to school_admins_path, notice: 'School was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.new
  end

  def find_admin
    @admin = SchoolAdmin.find(params[:id])
  end

  def school_params
    params.require(:user).permit(:name, :email, :school_ids)
  end

  def authorized_admin!
    return if current_user.admin?

    redirect_to root_path
  end
end
