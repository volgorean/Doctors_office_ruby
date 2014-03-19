require 'pg'
require './lib/doctor.rb'
require './lib/patient.rb'

DB = PG.connect({:dbname => 'doctors_office'})

def main_menu
  system('clear')
  puts "Welcome to your doctor's office"
  puts "view who - View doctors/patients on record"
  choice = gets.chomp.downcase.split
  case choice[0]
  when 'view'
    choice.shift
    case choice.join(" ")
    when 'doctors'
      view_doctors
    when 'patients'
      view_patients
    else
      #can add name search
      main_menu
    end
  else
    puts "Invalid entry"
    main_menu
  end
end

def view_doctors
  system('clear')
  puts "DOCTORS:"
  Doctor.all.each_with_index do |doctor, index|
    puts "#{index + 1}. #{doctor.name} - Specialises in: #{search_specialty_by_number(doctor.specialty_id)} - Insurance Accepted: #{search_insurance_by_number(doctor.insurance_id)}"
  end
  puts "'A' - Add a doctor"
  puts "'E' - Edit a doctor"
  puts "'M' - Main menu"
  choice = gets.chomp.upcase
  case choice
  when 'A'
    add_doctor
  when 'E'
    puts "Enter the name of the doctor you want to edit"
    edit_doctor(gets.chomp)
  when 'M'
    main_menu
  else
    puts "Invalid entry"
    sleep(2)
    view_doctors
  end
end

def add_doctor
  system('clear')
  puts "Type your doctor's name"
  doctor_name = gets.chomp.capitalize
  puts "Type your doctor's specialty"
  doctor_specialty = gets.chomp
  puts "Type your doctor's insurance"
  doctor_insurance = gets.chomp
  specialty_id = search_specialty_by_name(doctor_specialty)
  insurance_id = search_insurance_by_name(doctor_insurance)
  new_doctor = Doctor.new({"name" => doctor_name, "specialty_id" => specialty_id, "insurance_id" => insurance_id})
  new_doctor.save
  puts "\nDoctor #{new_doctor.name} has been added."
  sleep(1)
  view_doctors
end

def edit_doctor(name_of_doctor)
  system('clear')
  puts "what do you want to edit name/insurance/specialty [newvalue]"
  new_value = gets.chomp.split
  case new_value.shift
  when "name"
    DB.exec("UPDATE doctors SET name = '#{new_value.join(" ")}' WHERE name = ('#{name_of_doctor}');")
  when "insurance"
    new_value = search_insurance_by_name(new_value.join(" ")).to_i
    DB.exec("UPDATE doctors SET insurance_id = '#{new_value}' WHERE name = ('#{name_of_doctor}');")
  when "specialty"
    new_value = search_specialty_by_name(new_value.join(" ")).to_i
    DB.exec("UPDATE doctors SET specialty = '#{new_value}' WHERE name = ('#{name_of_doctor}');")
  else
    puts "Эrr0Я"
    sleep(2)
  end
  main_menu
end

def view_patients
  system('clear')
  puts "PATIENTS:"
  Patient.all.each_with_index do |patient, index|
    puts "#{index + 1}. #{patient.name} - Birthdate: #{patient.birthdate[0..9]} - Insurance: #{search_insurance_by_number(patient.insurance_id)} - Doctor: #{search_doctor_by_number(patient.doctor_id)}"
  end
  puts "'A' - Add a patient"
  puts "'E' - Edit a patient"
  puts "'M' - Main menu"
  choice = gets.chomp.upcase
  case choice
  when 'A'
    add_patient
  when 'E'
    puts "What is the patient's name?"
    edit_patient(gets.chomp.capitalize)
  when 'M'
    main_menu
  else
    puts "Invalid entry"
    sleep(2)
    view_patients
  end
end

def add_patient
  system('clear')
  puts "Type your patient's name"
  patient_name = gets.chomp.capitalize
  puts "what is #{patient_name}'s birthday (in format YYYY-MM-DD)"
  patient_birthdate = gets.chomp
  puts "Type your patient's insurance"
  insurance_id = search_insurance_by_name(gets.chomp)
  puts "DOCTORS:"
  Doctor.all.each_with_index do |doctor, index|
    puts "#(ID #{doctor.id}) #{doctor.name} - Specialises in: #{search_specialty_by_number(doctor.specialty_id)} - Insurance Accepted: #{search_insurance_by_number(doctor.insurance_id)}"
  end
  puts "Please select the number of your doctor."
  doctor_id = gets.chomp.to_i
  begin
    new_patient = Patient.new({"name" => patient_name, "birthdate" => patient_birthdate, "doctor_id" => doctor_id, "insurance_id" => insurance_id})
    new_patient.save
  rescue
    puts "Invalid entry, check your spelling and try again"
    sleep(2)
    add_patient
  end
  puts "\nPatient #{new_patient.name} has been added."
  sleep(1)
  view_patients
end

def edit_patient(name_of_patient)
  system('clear')
  puts "what do you want to edit name/birthdate/insurance/doctor [newvalue]"
  new_value = gets.chomp.split
  case new_value.shift
  when "name"
    DB.exec("UPDATE patients SET name = '#{new_value.join(" ")}' WHERE name = ('#{name_of_patient}');")
  when "birthdate"
    begin
      DB.exec("UPDATE patients SET birthdate = '#{new_value}' WHERE name = ('#{name_of_patient}');")
    rescue
      puts "Invalid birthdate. Please enter in format YYYY-MM-DD."
      sleep(2)
      edit_patient(name_of_patient)
    end
  when "insurance"
    new_value = search_insurance_by_name(new_value.join(" ")).to_i
    DB.exec("UPDATE patients SET insurance_id = '#{new_value}' WHERE name = ('#{name_of_patient}');")
  when "doctor"
    new_value = search_doctor_by_name(new_value.join(" ")).to_i
    DB.exec("UPDATE patients SET doctor_id = '#{new_value}' WHERE name = ('#{name_of_patient}');")
  else
    puts "Эrr0Я"
    sleep(2)
  end
  main_menu
end

def search_insurance_by_name(name)
  insurance_id = 4
  begin
    insurance_id = DB.exec("SELECT * FROM insurance WHERE name = ('#{name}');")[0]["id"]
  rescue
    insurance_id
  end
end

def search_insurance_by_number(number)
  insurance_name = ""
  if number.to_i > 0
    insurance_name = DB.exec("SELECT * FROM insurance WHERE id = ('#{number.to_i}');")[0]["name"]
  end
  insurance_name
end

def search_specialty_by_name(name)
  specialty_id = 3
  begin
    specialty_id = DB.exec("SELECT * FROM specialties WHERE name = ('#{name}');")[0]["id"]
  rescue
    specialty_id
  end
end

def search_specialty_by_number(number)
  specialty_name = ""
  if number.to_i > 0
    specialty_name = DB.exec("SELECT * FROM specialties WHERE id = ('#{number.to_i}');")[0]["name"]
  end
  specialty_name
end

def search_doctor_by_number(number)
  doctor_name = "Not assigned"
  if number.to_i > 0
    doctor_name = DB.exec("SELECT * FROM doctors WHERE id = ('#{number.to_i}');")[0]["name"]
  end
  doctor_name
end

def search_doctor_by_name(name)
  doctor_id = 0
  begin
    doctor_id = DB.exec("SELECT * FROM doctors WHERE name = ('#{name}');")[0]["id"]
  rescue
    puts "no doctor found"
    sleep(2)
  end
end

main_menu
