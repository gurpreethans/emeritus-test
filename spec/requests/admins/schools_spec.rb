# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Schools', type: :request do
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in admin
  end

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let!(:school) { FactoryBot.create(:school) }

  describe 'GET' do
    context 'when listing schools' do
      it 'returns schools' do
        get schools_path, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end

  describe 'POST' do
    context 'when creating school with invalid data' do
      it 'returns error' do
        post schools_path, params: { school: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when creating school with valid data' do
      it 'creates school' do
        post schools_path, params: { school: { name: 'Sophia' } }.to_json, headers: headers
        expect(response.status).to eq(201)
        data = JSON.parse response.body
        expect(data['name']).to eq('Sophia')
      end
    end
  end

  describe 'PUT' do
    context 'when updating school with invalid data' do
      it 'returns error' do
        put school_path(school), params: { school: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when updating school with valid data' do
      it 'udpates school' do
        put school_path(school), params: { school: { name: 'Green' } }.to_json, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['name']).to eq('Green')
      end
    end
  end

  describe 'DESTROY' do
    context 'when deleting school' do
      it 'deletes school' do
        delete school_path(school), headers: headers
        expect(response.status).to eq(204)
        expect(School.count).to eq(0)
      end
    end
  end
end
