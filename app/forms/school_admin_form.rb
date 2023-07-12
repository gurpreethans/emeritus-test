# frozen_string_literal: true

class SchoolAdminForm
  include ActiveModel::Model

  attr_accessor :name, :email, :school_ids

  validates :name, :school_ids, presence: true
  validates :email, presence: true, email_format: true
  validate :duplicate_admin?

  def initialize(user, params = {})
    @name = params[:name] || user.name
    @email = params[:email] || user.description
    @school_ids = params[:school_ids]
    user.assign_attributes(attributes)
  end

  def attributes
    {
      name: name,
      email: email,
      school_ids: school_ids
    }
  end

  def duplicate_admin?
    errors.add(:email, 'user already a school admin') if SchoolAdmin.joins(:user).exists?(user: { email: email },
                                                                                          school_id: school_ids)
  end
end
