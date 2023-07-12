# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Schools', type: :request do
  let(:school_admin_user) { FactoryBot.create(:school_admin_user) }

  before do
    sign_in school_admin_user
  end

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let(:school) { FactoryBot.create(:school) }
  let!(:school_admin) { FactoryBot.create(:school_admin, user: school_admin_user, school: school) }

  describe 'GET' do
    context 'when listing schools' do
      it 'returns schools' do
        get my_schools_path, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end

  describe 'PUT' do
    context 'when updating school with invalid data' do
      it 'returns error' do
        put my_school_path(school), params: { school: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when updating school with valid data' do
      it 'udpates school' do
        put my_school_path(school), params: { school: { name: 'Green' } }.to_json, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['name']).to eq('Green')
      end
    end
  end
end
