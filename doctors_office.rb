require 'pg'
require './lib/doctor.rb'

DB = PG.connect({:dbname => 'doctors_office'})

def main_menu
  system('clear')
  puts "Welcome to your doctor's office"
  puts "'V' - View doctors"
  choice = gets.chomp.upcase
  case choice
  when 'V'
    view_doctors
  else
    puts "Invalid entry"
    main_menu
  end
end

def view_doctors
  system('clear')
  puts "DOCTORS:"
  Doctor.all.each_with_index do |doctor, index|
    puts "#{index + 1}. #{doctor.name}"
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
  doctor_specialty = 0 #NEED TO ADD FUNCTIONALITY
  doctor_insurance = 0
  new_doctor = Doctor.new({:name => doctor_name, :specialty => doctor_specialty, :insurance => doctor_insurance})
  new_doctor.save
  puts "\nDoctor #{new_doctor.name} has been added."
  sleep(1)
  view_doctors
end

main_menu
