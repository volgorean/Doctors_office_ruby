require 'pg'

class Doctor
  attr_reader(:name, :specialty_id, :insurance_id, :id)

  def initialize(attributes)
    @name = attributes['name']
    @specialty_id = attributes['specialty_id']
    @insurance_id = attributes['insurance_id']
    @id = attributes["id"].to_i || 000
  end

  def change_insurance_id(new_insurance_id)
    @insurance_id = new_insurance_id
  end

  def change_specialty_id(new_specialty_id)
    @specialty_id = new_specialty_id
  end

  def ==(another_doctor)
    self.name == another_doctor.name && self.specialty_id == another_doctor.specialty_id && self.insurance_id == another_doctor.insurance_id && self.id == another_doctor.id
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty_id, insurance_id) VALUES ('#{@name}', #{@specialty_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |doctor|
      doctors << Doctor.new(doctor)
    end
    doctors
  end
end
