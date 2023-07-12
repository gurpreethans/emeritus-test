# frozen_string_literal: true

class ManageSchoolAdmin
  attr_reader :user, :admin

  def self.call(attributes)
    new(attributes).call
  end

  def initialize(attributes)
    @attributes = attributes
    @school_id = @attributes.delete(:school_ids)
  end

  def call
    ActiveRecord::Base.transaction do
      @user = existing_user
      if @user
        update_role
      else
        create_user
      end
      create_school_admin
    end

    send_invite
    self
  end

  def existing_user
    User.find_by(email: @attributes[:email])
  end

  def create_user
    @user = User.create!(
      name: @attributes[:name],
      email: @attributes[:email],
      password: 'Hello123',
      role: User::SCHOOL_ADMIN
    )
  end

  def update_role
    return if @user.school_admin?

    @user.update!(role: User::SCHOOL_ADMIN)
  end

  def create_school_admin
    @admin = SchoolAdmin.create!(
      user_id: user.id,
      school_id: @school_id
    )
  end

  def send_invite
    # TO DO: Add email to send invitation link
  end
end
