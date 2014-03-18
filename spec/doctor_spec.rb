require 'rspec'
require 'spec_helper'
require 'doctor'

describe Doctor do
  it 'creates a doctor object with name' do
    test_doctor = Doctor.new({:name => "mr. bob"})
    test_doctor.should be_an_instance_of Doctor
  end

  it 'gives us the name of the doctor' do
    test_doctor = Doctor.new({:name => "mr. bob"})
    test_doctor.name.should eq "mr. bob"
  end

  it 'gives us the specialty and insurance accepted by the doctor' do
    test_doctor = Doctor.new({:name => "mr. bob", :specialty => "optometry",:insurance => "Red Shield"})
    test_doctor.specialty.should eq "optometry"
    test_doctor.insurance.should eq "Red Shield"
  end

  it 'allows us to change the doctors insurance' do
    test_doctor = Doctor.new({:name => "mr. Cat"})
    test_doctor.change_insurance("Red Shield")
    test_doctor.insurance.should eq "Red Shield"
  end

  it 'allows us to change the doctors specialty' do
    test_doctor = Doctor.new({:name => "mr. Cat"})
    test_doctor.change_specialty("Neurology")
    test_doctor.specialty.should eq "Neurology"
  end

  describe 'save' do
    it 'saves a doctor object' do
      test_doctor = Doctor.new({:name => 'mr. dog'})
      test_doctor.save
      Doctor.all.should eq [test_doctor]
    end
  end

  describe '.all' do
    it 'starts out empty' do
      test_doctor = Doctor.new({:name => "mr. dog"})
      Doctor.all.should eq []
    end
  end
end
