class Patient
  attr_reader(:name, :birthday, :id)
  def initialize(attributes)
    @name = attributes['name']
    @birthday = attributes['birthday']
    @id = attributes['id']
  end

  def self.all
    patients = []
  end

  def ==(another_patient)
    self.name == another_patient.name && self.id == another_patient.id
  end
end
