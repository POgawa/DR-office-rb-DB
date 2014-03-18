require 'rspec'
require 'doctor'

describe 'Doctor' do
  it 'initializes an instance of doctor' do
    test_doctor = Doctor.new('Dr Octopus', 'Mayhem')
    test_doctor should be_an_instance_of Doctor
  end

end
