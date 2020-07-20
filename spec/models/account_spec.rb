require 'rails_helper'

RSpec.describe Account, type: :model do
  context 'account number invalid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
    it 'is invalid if account number format is wrong'
    it 'is invalid if account number is not unique'
    # expect(subject).to_not be_valid
  end
  context 'account number valid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
    it 'is invalid if account number format is wrong'
    it 'is invalid if account number is not unique'
    # expect(subject).to be_valid
  end

  context 'password invalid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
    it 'is invalid if account number format is wrong'
    it 'is invalid if account number is not unique'
  end
  context 'password valid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
    it 'is invalid if account number format is wrong'
    it 'is invalid if account number is not unique'
  end

  context 'money amount invalid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
  end
  context 'money amount valid tests' do
    it 'is invalid if has no account number'
    it 'is invalid if account number length is less than 6'
    it 'is invalid if account number length is grater than 6'
  end

end
