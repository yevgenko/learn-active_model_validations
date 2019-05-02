require 'active_model'

RSpec.describe Learn::ActiveModelValidations do
  let(:person_class) do
    Struct.new(:first_name, :last_name) do
      include ActiveModel::Validations

      validates_each :first_name, :last_name do |record, attr, value|
        record.errors.add attr, 'starts with z.' if value.to_s[0] == ?z
      end
    end
  end

  it "verifies validity of the entity" do
    expect(person_class.new).to               be_valid
    expect(person_class.new('aaa', 'aaa')).to be_valid

    expect(person_class.new('zzz')).to        be_invalid
    expect(person_class.new('aaa', 'zzz')).to be_invalid
  end

  it 'reports errors messages' do
    invalid_person = person_class.new('zzz')

    expect{
      invalid_person.valid?
    }.to change{
      invalid_person.errors.messages
    }.from({}).to(
      { first_name: ["starts with z."] }
    )
  end
end
