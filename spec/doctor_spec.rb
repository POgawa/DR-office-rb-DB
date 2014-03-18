require 'rspec'
require 'doctor'
require 'pg'
require 'spec_helper'

describe 'Doctor' do
  it 'initializes an instance of doctor' do
    test_doctor = Doctor.new({'name' =>'Dr Octopus', 'specialty' => 'Mayhem', 'id' => 1})
    test_doctor.should be_an_instance_of Doctor
  end

  it('is the same doctor if it has the same name and id') do
    doc1 = Doctor.new({'name' =>'Dr Octopus', 'specialty' => 'Mayhem', 'id' => 1})
    doc2 = Doctor.new({'name' =>'Dr Octopus', 'specialty' => 'Mayhem', 'id' => 1})
    doc1.should eq doc2
  end

  it 'starts off with no doctors' do
    Doctor.all.should eq []
  end

  it('lets you save doctors to the database') do
    doc1 = Doctor.new({'name' =>'Dr Octopus', 'specialty' => 'Mayhem', 'id' => 1})
    doc1.save
    Doctor.all.should(eq([doc1]))
  end

  it 'sets its id when you save it' do
    doctor = Doctor.new({'name' => 'Dr Octopus' })
    doctor.save
    doctor.id.should be_an_instance_of Fixnum
  end
end


