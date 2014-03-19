require 'spec_helper'
require 'patient'

describe 'Patient' do
  it 'creates an instance of patient' do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'doc_id' => 1})
    patient1.should be_an_instance_of Patient
  end
  it('can be initialized with its database ID') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'doc_id' => 1})
    patient1.should(be_an_instance_of(Patient))
  end
  it('tells you its name') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'doc_id' => 1})
    patient1.name.should(eq('Bob the baker'))
  end
  it ('starts off with no patients') do
    Patient.all.should eq []
  end
  it('should equal the same list if the name and id are the same') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'doc_id' => 1})
    patient2 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'doc_id' => 1})
    patient1.should(eq(patient2))
  end
  it ('lets you save the info to a database') do
    patient1 = Patient.new({ 'name' => 'bob the baker', 'birthday' => '1984-01-02 00:00:00', 'doc_id' => 1})
    patient1.save
    Patient.all.should eq [patient1]
  end
  it('should rebuild an object from the database') do
    patient1 = Patient.new({ 'name' => 'bob the baker', 'birthday' => '1984-01-02 00:00:00', 'doc_id' => 1})
    patient1.save
    test = DB.exec('SELECT * FROM patients')
    patient2 = Patient.rebuild(test)
    patient2.should(eq(patient1))
  end

end


