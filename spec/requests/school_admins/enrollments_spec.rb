require 'rails_helper'
RSpec.describe 'Enrollments', type: :request do
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

  let(:student) { FactoryBot.create(:student) }
  let(:student_2) { FactoryBot.create(:student, email: 'student2@example.com') }
  let(:school) { FactoryBot.create(:school) }
  let!(:school_admin) { FactoryBot.create(:school_admin, user: school_admin_user, school: school) }
  let(:course) { FactoryBot.create(:course, school: school) }
  let(:batch) { FactoryBot.create(:batch, course: course) }
  let!(:enrollment) { FactoryBot.create(:enrollment, user: student, batch: batch) }

  describe 'GET' do
    context 'when listing enrollments' do
      it 'returns enrollments' do
        get my_school_course_batch_enrollments_path(school, course, batch), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end

    context 'when approve enrollment request' do
      it 'approves student enrollment' do
        get update_status_my_school_course_batch_enrollment_path(school, course, batch, enrollment, status: Enrollment::APPROVED), headers: headers
        expect(response.status).to eq(204)
        expect(enrollment.reload.status).to eq(Enrollment::APPROVED)
      end
    end

    context 'when reject enrollment request' do
      it 'rejects student enrollment' do
        get update_status_my_school_course_batch_enrollment_path(school, course, batch, enrollment, status: Enrollment::REJECTED), headers: headers
        expect(response.status).to eq(204)
        expect(enrollment.reload.status).to eq(Enrollment::REJECTED)
      end
    end
  end

  describe 'POST' do
    context 'when enrolling student' do
      it 'enrolls student' do
        post my_school_course_batch_enrollments_path(school, course, batch), params: { student_ids: [student_2.id] }.to_json, headers: headers
        expect(response.status).to eq(201)
        data = JSON.parse response.body
        expect(data['message']).to eq('Students were successfully enrolled.')
      end
    end
  end

  describe 'DESTROY' do
    context 'when disenroll student' do
      it 'disenrolls student' do
        delete my_school_course_batch_enrollment_path(school, course, batch, enrollment), headers: headers
        expect(response.status).to eq(204)
        expect(Enrollment.find_by(id: enrollment)).to be_nil
      end
    end
  end
end
