require 'rails_helper'
RSpec.describe 'Batches', type: :request do
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
  let(:course) { FactoryBot.create(:course, school: school) }
  let!(:batch) { FactoryBot.create(:batch, course: course) }

  describe 'GET' do
    context 'when listing batches' do
      it 'returns batches' do
        get students_course_batches_path(course), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end
  end
end
