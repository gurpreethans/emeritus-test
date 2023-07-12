require 'rails_helper'
RSpec.describe 'Courses', type: :request do
  let(:student) { FactoryBot.create(:student)  }

  before do
    sign_in student
  end

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let(:school) { FactoryBot.create(:school) }
  let!(:school_student) { FactoryBot.create(:school_student, user: student, school: school) }
  let!(:course) { FactoryBot.create(:course, school: school) }

  describe 'GET' do
    context 'when listing school courses' do
      it 'returns courses' do
        get students_courses_path, headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end
end
