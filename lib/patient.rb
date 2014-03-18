class Patient
  attr_reader :name, :birthdate, :doctor_id, :insurance_id, :id

  def initialize(attributes)
    @name = attributes['name']
    @birthdate = attributes["birthdate"] # || '1900-01-01 00:00:00'
    @doctor_id = attributes["doctor_id"].to_i || 000
    @insurance_id = attributes["insurance_id"].to_i || 000
    @id = attributes["id"].to_i || 000
  end

  def save
    results = DB.exec("INSERT INTO patients (name, birthdate, doctor_id, insurance_id)  VALUES ('#{@name}', '#{@birthdate}', #{@doctor_id}, #{@insurance_id}) RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(another_patient)
    self.name == another_patient.name && self.birthdate == another_patient.birthdate && self.doctor_id == another_patient.doctor_id && self.insurance_id == another_patient.insurance_id && self.id == another_patient.id
  end

  def change_insurance(new_insurance)
    @insurance_id = new_insurance
  end

  def change_doctor(new_doctor)
    @doctor_id = new_doctor
  end

  def self.all
    results = DB.exec("SELECT * FROM patients;")
    patients = []
    results.each do |patient|
      patients << Patient.new(patient)
    end
    patients
  end
end
