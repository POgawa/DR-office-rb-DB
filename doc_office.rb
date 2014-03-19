require('./lib/patient')
require('./lib/doctor')
require('pg')
require('date')

DB = PG.connect(:dbname => 'doc_office')

def welcome
  puts "Welcome to the patient tracker"
  main_menu
end

def main_menu
  puts "D - Access doctors"
  puts "P - Access patients"
  puts "X - Exit"

  case gets.chomp.upcase
  when 'D'
    doctors()
  when 'P'
    patients()
  when 'X'
    puts "Thank you please come again"
  else
    puts "Invalid Input"
    main_menu()
  end
end

def patients
  puts "A - Add a patient"
  puts "S - Search for a patient"
  puts "L - List all patients"
  puts "X - Go back"

  case gets.chomp.upcase
  when 'A'
    system('clear')
    puts "Please enter patients name:"
    new_name = gets.chomp.downcase
    puts "Please enter birthyear:"
    new_birthyear = gets.chomp.to_i
    puts "Please enter birth month:"
    new_birthmonth = gets.chomp.to_i
    puts "Please enter birth day:"
    new_birthdate = gets.chomp.to_i
    Patient.add(new_name, new_birthyear, new_birthmonth, new_birthdate)
    puts "Patient added!"
    patients()
  when 'S'
    puts 'Please enter the name of the patient you wish to search for'
    input_name = gets.chomp.downcase
    Patient.search(input_name)
  when 'L'
    Patient.list
  when 'X'
    main_menu()
  else
    puts "Invalid Input"

    patients
  end
end

def doctors
  puts "A - Add a doctor"
  puts "S - Search for a doctor"
  puts "L - List all doctors"
  puts "X - Go back"

  case gets.chomp.upcase
  when 'A'
    add_doctor
  when 'S'
    doctor_search
  when 'L'
    list_doctors
  when 'X'
    main_menu()
  else
    puts "Invalid Input"
  end
end

def patient_data(selected_patient)
  puts "Patients name is: #{selected_patient.name}"
  puts "Patients birthdate is: #{selected_patient.birthday}"
  if selected_patient.doc_id == 0
    puts "Patient has no doctor assigned"
  else
    returned_doc = selected_patient.get_doc
    puts "Patients Doctor is: #{returned_doc.first['name']}\n\n"
  end
  puts "E - Edit this information"
  puts "X - Back"
  case gets.chomp.upcase
  when 'E'
    edit_patient(selected_patient)
  when 'X'
    patients
  else
    puts 'invalid input'
    patient_data(selected_patient)
  end
  # patients()
end

def edit_patient(selected_patient)
  puts "N - Edit name"
  puts "B - Edit birthday"
  puts "D - Edit doctor"
  puts "R - Remove patient"
  case gets.chomp.upcase

  when 'N'
    puts 'Enter new name:'
    input_name = gets.chomp
    selected_patient.edit_name(input_name)
  when 'B'
    puts 'Enter new birth year'
    input_year = gets.chomp.to_i
    puts 'Enter new birth month'
    input_month = gets.chomp.to_i
    puts 'Enter new birth day'
    input_day = gets.chomp.to_i
    selected_patient.edit_birth(input_year, input_month, input_day)
  when 'D'
    puts "Edit this patients doctor"
    puts "Here is a list of doctors:"
    list_doctors
    puts "Select doctors number"
    input = gets.chomp.to_i
    selected_patient.edit_doctor(input)
  when 'R'
    puts 'Would you like to delete this patient? y/n'

    case gets.chomp.upcase
    when'Y'
      selected_patient.delete
      patients
    when 'N'
      edit_patient(selected_patient)
    else
      puts 'invalid input'
      edit_patient(selected_patient)
    end
  else
    puts 'invalid input'
    edit_patient(selected_patient)
  end
end

def add_doctor
  system('clear')
  puts "Please enter doctors name:"
  new_name = gets.chomp.downcase
  puts "Enter the doctors specialty"
  specialty = gets.chomp
  new_doctor = Doctor.new({'name' => new_name, 'specialty' => specialty})
  new_doctor.save
  doctors()
end

def doctor_search
  puts 'Please enter the name of the doctor you wish to search for'
  result = DB.exec("SELECT * FROM doctors WHERE name LIKE '#{gets.chomp.downcase}%';")
  result.each do |doctor|
    split_name = doctor['name'].split(' ')
    split_name.each do |name|
      name.capitalize!
    end
    puts split_name.join(' ')
  end
  doctors()
end

def list_doctors
  result = DB.exec("SELECT * FROM doctors;")
  result.each do |doctor|
    split_name = doctor['name'].split(' ')
    split_name.each do |name|
      name.capitalize!
    end
    puts "#{doctor['id']}: #{split_name.join(' ')}"
  end
end




welcome
