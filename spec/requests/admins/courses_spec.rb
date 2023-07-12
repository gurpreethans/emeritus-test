require 'rails_helper'
RSpec.describe 'Courses', type: :request do
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
  let!(:course) { FactoryBot.create(:course, school: school) }

  describe 'GET' do
    context 'when listing courses' do
      it 'returns courses' do
        get my_school_courses_path(school), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end

  describe 'POST' do
    context 'when creating course with invalid data' do
      it 'returns error' do
        post my_school_courses_path(school), params: { course: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when creating course with valid data' do
      it 'creates course' do
        post my_school_courses_path(school), params: { course: { name: 'MBA' } }.to_json, headers: headers
        expect(response.status).to eq(201)
        data = JSON.parse response.body
        expect(data['name']).to eq('MBA')
      end
    end
  end

  describe 'PUT' do
    context 'when updating course with invalid data' do
      it 'returns error' do
        put my_school_course_path(school, course), params: { course: { name: '' } }.to_json, headers: headers
        expect(response.status).to eq(422)
        data = JSON.parse response.body
        expect(data['name'].first).to eq("can't be blank")
      end
    end

    context 'when updating course with valid data' do
      it 'udpates course' do
        put my_school_course_path(school, course), params: { course: { name: 'BBA' } }.to_json, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['name']).to eq('BBA')
      end
    end
  end

  describe 'DESTROY' do
    context 'when deleting course' do
      it 'deletes course' do
        delete my_school_course_path(school, course), headers: headers
        expect(response.status).to eq(204)
        expect(Course.count).to eq(0)
      end
    end
  end
end
