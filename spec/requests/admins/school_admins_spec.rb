require 'rails_helper'
RSpec.describe 'Schools', type: :request do
  let(:admin) { FactoryBot.create(:admin)  }

  before do
    sign_in admin
  end

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let(:school) { FactoryBot.create(:school) }
  let(:school_admin_user) { FactoryBot.create(:school_admin_user) }
  let!(:school_admin) { FactoryBot.create(:school_admin, user: school_admin_user, school: school) }

  describe 'GET' do
    context 'when listing school admins' do
      it 'returns school admins' do
        get school_admins_path, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end

  describe 'POST' do
    context 'when creating school admin with invalid data' do
      it 'returns error' do
        post school_admins_path, params: { user: { name: '', email: 'school@example.com', school_ids: school.id } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when creating duplicate school admin' do
      it 'returns error' do
        post school_admins_path, params: { user: { name: 'Josh', email: school_admin.email, school_ids: school.id } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['email'].first).to eq("user already a school admin")
      end
    end

    context 'when creating school with valid data' do
      it 'create school' do
        post school_admins_path, params: { user: { name: 'Josh', email: 'school@example.com', school_ids: school.id } }.to_json, headers: headers
        expect(response.status).to eq(201)
        data = JSON.parse response.body
        expect(data['name']).to eq('Josh')
        expect(data['email']).to eq('school@example.com')
      end
    end
  end

  describe 'DESTROY' do
    context 'when deleting school admin' do
      it 'deletes school admin rights' do
        delete school_admin_path(school_admin), headers: headers
        expect(response.status).to eq(204)
        expect(SchoolAdmin.count).to eq(0)
      end
    end
  end
end
