require 'pg'

class Doctor
  attr_reader(:name, :specialty, :insurance, :doctors, :id)

  def initialize(attributes)
    @name = attributes[:name]
    @specialty = attributes[:specialty] || 000
    @insurance = attributes[:insurance] || 000
    @id = attributes[:id] || 000
    @doctors = []
  end

  def change_insurance(new_insurance)
    @insurance = new_insurance
  end

  def change_specialty(new_specialty)
    @specialty = new_specialty
  end

  def ==(another_doctor)
    self.name == another_doctor.name && self.specialty == another_doctor.specialty && self.insurance == another_doctor.insurance && self.id == another_doctor.id
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty}, #{@insurance}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |doctor|
      name = doctor['name']
      specialty_id = doctor['specialty_id'].to_i
      insurance_id = doctor['insurance_id'].to_i
      id = doctor['id'].to_i
      doctors << Doctor.new({:name => name, :insurance => insurance_id, :specialty => specialty_id, :id => id})
    end
    doctors
  end
end
