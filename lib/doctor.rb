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
end
