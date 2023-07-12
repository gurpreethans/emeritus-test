require 'rails_helper'
RSpec.describe 'Batches', type: :request do
  let(:school_admin_user) { FactoryBot.create(:school_admin_user)  }

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
  let(:course) { FactoryBot.create(:course, school: school) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }

  describe 'GET' do
    context 'when listing batches' do
      it 'returns batches' do
        get my_school_course_batches_path(school, course), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end

  describe 'POST' do
    context 'when creating course with invalid data' do
      it 'returns error' do
        post my_school_course_batches_path(school, course), params: { batch: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when creating course with valid data' do
      it 'creates course' do
        post my_school_course_batches_path(school, course), params: { batch: { name: '2022' } }.to_json, headers: headers
        expect(response.status).to eq(201)
        data = JSON.parse response.body
        expect(data['name']).to eq('2022')
      end
    end
  end

  describe 'PUT' do
    context 'when updating course with invalid data' do
      it 'returns error' do
        put my_school_course_batch_path(school, course, batch), params: { batch: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when updating course with valid data' do
      it 'udpates course' do
        put my_school_course_batch_path(school, course, batch), params: { batch: { name: '2021' } }.to_json, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['name']).to eq('2021')
      end
    end
  end

  describe 'DESTROY' do
    context 'when deleting course' do
      it 'deletes course' do
        delete my_school_course_batch_path(school, course, batch), headers: headers
        expect(response.status).to eq(204)
        expect(Batch.count).to eq(0)
      end
    end
  end
end
