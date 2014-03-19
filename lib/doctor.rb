class Doctor
  attr_reader(:name, :id, :specialty)
  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
    @specialty = attributes['specialty']
  end
  def ==(another_doctor)
    self.name == another_doctor.name && self.id == another_doctor.id
  end
  def self.all
    results = DB.exec("SELECT * FROM doctors;")
    doctors = []
    results.each do |result|
      name = result['name']
      id = result['id'].to_i
      specialty = result['specialty']
      doctors << Doctor.new({'name' => name, 'specialty' => specialty, 'id' => id})
    end
    doctors
  end

  def save
    results = DB.exec("INSERT INTO doctors (name, specialty) VALUES ('#{@name}', '#{@specialty}') RETURNING id;")
    @id = results.first['id'].to_i
  end

def self.search(input_name)
    result = DB.exec("SELECT * FROM doctors WHERE name LIKE '#{input_name}%';")
    result.each do |doctor|
      split_name = doctor['name'].split(' ')
      split_name.each do |name|
        name.capitalize!
      end
      puts split_name.join(' ')
    end
  end

  def self.add(new_name, specialty)
    new_doctor = Doctor.new({'name' => new_name, 'specialty' => specialty })
    new_doctor.save
  end

  def self.list
    result = DB.exec("SELECT * FROM doctors;")
    result.each do |doctor|
      split_name = doctor['name'].split(' ')
      split_name.each do |name|
        name.capitalize!
      end
      puts "#{doctor['id']}: #{split_name.join(' ')}"
    end
    puts "Enter the ID of the doctor whose data you would like to see"

    selected_doctor = DB.exec("SELECT * FROM doctors WHERE id = #{gets.chomp.to_i};")
    patient_data(selected_patient)
  end


end
