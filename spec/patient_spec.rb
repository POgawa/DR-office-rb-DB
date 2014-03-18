require 'spec_helper'
require 'patient'

describe 'Patient' do
  it 'creates an instance of patient' do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'id' => 1})
    patient1.should be_an_instance_of Patient
  end
  it('can be initialized with its database ID') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'id' => 1})
    patient1.should(be_an_instance_of(Patient))
  end
  it('tells you its name') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'id' => 1})
    patient1.name.should(eq('Bob the baker'))
  end
  it ('starts off with no patients') do
    Patient.all.should eq []
  end
  it('should equal the same list if the name and id are the same') do
    patient1 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'id' => 1})
    patient2 = Patient.new({ 'name' => 'Bob the baker', 'birthday' => '1984-01-02', 'id' => 1})
    patient1.should(eq(patient2))
  end
end
