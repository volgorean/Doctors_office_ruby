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
  puts "'M' - Main menu"
  choice = gets.chomp.upcase
  case choice
  when 'A'
    add_doctor
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

def view_patients
  system('clear')
  puts "PATIENTS:"
  Patient.all.each_with_index do |patient, index|
    puts "#{index + 1}. #{patient.name}"
  end
  puts "'A' - Add a patient"
  puts "'M' - Main menu"
  choice = gets.chomp.upcase
  case choice
  when 'A'
    add_patient
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
  puts "what is #{patient_name}'s birthday"
  patient_birthday = gets.chomp
  puts "Type your patient's insurance"
  patient_insurance = gets.chomp
  patient_birthday = 0 #NEED TO ADD FUNCTIONALITY
  patient_insurance = 0
  new_patient = Patient.new({"name" => patient_name, "birthday" => patient_birthday, "insurance" => patient_insurance})
  new_patient.save
  puts "\nPatient #{new_patient.name} has been added."
  sleep(1)
  view_patients
end

def search_insurance_by_name(name)
  insurance_id = 4
  if DB.exec("SELECT * FROM insurance;").include?(name)
    insurance_id = DB.exec("SELECT * FROM insurance WHERE name = ('#{name}');")[0]["id"]
  end
  insurance_id
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
  if DB.exec("SELECT * FROM specialties;").include?(name)
    specialty_id = DB.exec("SELECT * FROM specialties WHERE name = ('#{name}');")[0]["id"]
  end
  specialty_id
end

def search_specialty_by_number(number)
  specialty_name = ""
  if number.to_i > 0
    specialty_name = DB.exec("SELECT * FROM specialties WHERE id = ('#{number.to_i}');")[0]["name"]
  end
  specialty_name
end

main_menu
