# frozen_string_literal: true

module SchoolAdminPresenter
  def self.single(admin)
    {
      id: admin.id,
      name: admin.name,
      email: admin.email,
      school_name: admin.school_name
    }
  end

  def self.list(admins)
    admins.map do |admin|
      single(admin)
    end
  end
end
