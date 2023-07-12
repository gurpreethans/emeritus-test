# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Enrollments', type: :request do
  let(:student) { FactoryBot.create(:student) }

  before do
    sign_in student
  end

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let(:student_2) { FactoryBot.create(:student, email: 'student2@example.com') }
  let(:school) { FactoryBot.create(:school) }
  let!(:school_student) { FactoryBot.create(:school_student, user: student, school: school) }
  let(:course) { FactoryBot.create(:course, school: school) }
  let(:batch) { FactoryBot.create(:batch, course: course) }
  let!(:enrollment) { FactoryBot.create(:enrollment, user: student_2, batch: batch) }

  describe 'GET' do
    context 'when listing enrollments' do
      it 'returns enrollments' do
        get students_course_batch_enrollments_path(course, batch), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data.count).to eq(1)
      end
    end

    context 'when apply for enrollment' do
      it 'creates enrollment request' do
        get enroll_students_course_batch_enrollments_path(course, batch), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['message']).to eq('Enrollment request was successfully submitted.')
        expect(enrollment.reload.status).to eq(Enrollment::PENDING)
      end
    end

    context 'when withdraw enrollment request' do
      before do
        FactoryBot.create(:enrollment, user: student, batch: batch)
      end
      it 'deletes enrollment request' do
        get disenroll_students_course_batch_enrollments_path(course, batch), headers: headers
        expect(response.status).to eq(200)
        data = JSON.parse response.body
        expect(data['message']).to eq('Enrollment request was successfully destroyed.')
      end
    end
  end
end
