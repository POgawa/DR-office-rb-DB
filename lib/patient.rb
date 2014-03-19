class Patient
  attr_reader(:name, :birthday, :id, :doc_id)
  def initialize(attributes)
    @name = attributes['name']
    @birthday = attributes['birthday']
    @id = attributes['id'].to_i
    @doc_id = attributes['doc_id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM patients;")
    patients = []
    results.each do |result|
      patients << Patient.new(result)
    end
    patients
  end

  def self.rebuild(results)
    Patient.new(results.first)
  end

  def ==(another_patient)
    self.name == another_patient.name && self.id == another_patient.id
  end
  def save
    results = DB.exec("INSERT INTO patients (name, birthday, doc_id) VALUES ('#{@name.downcase}', '#{@birthday}', '#{@doc_id.to_i}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.search(input_name)
    result = DB.exec("SELECT * FROM patients WHERE name LIKE '#{input_name}%';")
    result.each do |patient|
      split_name = patient['name'].split(' ')
      split_name.each do |name|
        name.capitalize!
      end
      puts split_name.join(' ')
    end
  end

  def self.add(new_name, new_birthyear, new_birthmonth, new_birthdate)
    date = Date.new(new_birthyear, new_birthmonth, new_birthdate)
    new_patient = Patient.new({'name' => new_name, 'birthday' => date})
    new_patient.save
  end

  def self.list
    result = DB.exec("SELECT * FROM patients;")
    result.each do |patient|
      split_name = patient['name'].split(' ')
      split_name.each do |name|
        name.capitalize!
      end
      puts "#{patient['id']}: #{split_name.join(' ')}"
    end
    puts "Enter the ID of the patient whose data you would like to see"
    input = gets.chomp.to_i
    if input > 0
      database_patient = DB.exec("SELECT * FROM patients WHERE id = #{input};")
      selected_patient = Patient.rebuild(database_patient)
      patient_data(selected_patient)
    else
      puts 'Invalid input'
      patients
    end
  end

  def get_doc
     DB.exec("SELECT * FROM doctors WHERE id = #{@doc_id};")
  end
  def edit_name(input)
    DB.exec("UPDATE patients SET name = '#{input}' WHERE id = #{@id};")
    passed_patient = DB.exec("SELECT * FROM patients WHERE id = #{@id};")
    new_name = Patient.rebuild(passed_patient)
    patient_data(new_name)
  end
  def edit_birth(new_birthyear, new_birthmonth, new_birthdate)
    date = Date.new(new_birthyear, new_birthmonth, new_birthdate)
    DB.exec("UPDATE patients SET birthday = '#{date}' WHERE id = #{@id};")
    passed_patient = DB.exec("SELECT * FROM patients WHERE id = #{@id};")
    new_name = Patient.rebuild(passed_patient)
    patient_data(new_name)
  end

  def edit_doctor(input)
    DB.exec("UPDATE patients SET doc_id = '#{input}' WHERE id = #{@id};")
    passed_patient = DB.exec("SELECT * FROM patients WHERE id = #{@id};")
    new_name = Patient.rebuild(passed_patient)
    patient_data(new_name)
  end

  def delete
    DB.exec("DELETE FROM patients WHERE id = #{@id};")
  end

end


