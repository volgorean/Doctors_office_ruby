require 'rspec'
require 'spec_helper'
require 'patient'

describe Patient do
  it 'creates a patient object with name' do
    test_patient = Patient.new({"name" => "mr. bob"})
    test_patient.should be_an_instance_of Patient
  end

  it 'gives us the name of the patient' do
    test_patient = Patient.new({"name" => "mr. bob"})
    test_patient.name.should eq "mr. bob"
  end

  it 'gives us the specialty and insurance accepted by the patient' do
    test_patient = Patient.new({"name" => "mr. bob", "doctor_id" => 5, "insurance_id" => 6})
    test_patient.doctor_id.should eq 5
    test_patient.insurance_id.should eq 6
  end

  it 'allows us to change the patients insurance' do
    test_patient = Patient.new({"name" => "mr. Cat"})
    test_patient.change_insurance(6)
    test_patient.insurance_id.should eq 6
  end

  it 'allows us to change the patients specialty' do
    test_patient = Patient.new({"name" => "mr. Cat"})
    test_patient.change_doctor(5)
    test_patient.doctor_id.should eq 5
  end

  describe 'save' do
    it 'saves a patient object' do
      test_patient = Patient.new({'name' => 'mr. dog'})
      test_patient.save
      Patient.all.should eq [test_patient]
    end
  end

  describe '.all' do
    it 'starts out empty' do
      test_patient = Patient.new({"name" => "mr. dog"})
      Patient.all.should eq []
    end
  end
end
