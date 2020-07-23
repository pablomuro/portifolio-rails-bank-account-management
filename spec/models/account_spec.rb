require 'rails_helper'

RSpec.describe Account, type: :model do
  let(:account) { build(:account) }

  context 'account number invalid entries' do
    it 'is invalid if has no account number' do
      account.account_number = nil
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to include("can't be blank")
    end
    it 'is invalid if account number length is less than 6' do
      account.account_number = FFaker::Lorem.characters(3)
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to include('is the wrong length (should be 6 characters)')
    end
    it 'is invalid if account number length is grater than 6' do
      account.account_number = FFaker::Lorem.characters(9)
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to include('is the wrong length (should be 6 characters)')
    end
    it 'is invalid if account number format is wrong' do
      account.account_number = 123456
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to match_array(['account number format must be XXXX-X'])
      account.account_number = 'ASse-1'
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to match_array(['account number format must be XXXX-X'])
      account.account_number = '123A-1'
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to match_array(['account number format must be XXXX-X'])
      account.account_number = FFaker::String.from_regexp(/[A-Z-a-z-1-9-]{6}/)
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to match_array(['account number format must be XXXX-X'])
    end
    it 'is invalid if account number is not unique' do
      same_account_number = FFaker::String.from_regexp(/[0-9]{4}-[0-9]{1}/)
      create(:account, account_number: same_account_number)
      account.account_number = same_account_number
      account.save
      expect(account).to_not be_valid
      expect(account.errors.messages[:account_number]).to match_array(['has already been taken'])
    end
  end

  context 'password invalid entries' do
    it 'is invalid if has no password' do
      account.password = nil
      expect(account).to_not be_valid
      expect(account.errors.messages[:password]).to include("can't be blank")
    end
    it 'is invalid if password length is less than 6' do
      account.password = FFaker::Internet.password(1, 5)
      expect(account).to_not be_valid
      expect(account.errors.messages[:password]).to include('is too short (minimum is 6 characters)')
    end
    it 'is invalid if password length is grater than 16' do
      account.password = FFaker::Internet.password(17, 20)
      expect(account).to_not be_valid
      expect(account.errors.messages[:password]).to include('is too long (maximum is 16 characters)')
    end
    it 'is invalid if password and password_confirmation does not match' do
      account.password = FFaker::Internet.password(6, 16)
      account.password_confirmation = FFaker::Internet.password(6, 16) + 'error'
      expect(account).to_not be_valid
      expect(account.errors.messages[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context 'money amount invalid entries' do
    it 'is invalid if has no money amount' do
      account.money_amount = nil
      expect(account).to_not be_valid
      expect(account.errors.messages[:money_amount]).to include("can't be blank")
    end
    it 'is invalid if money amount is no a number' do
      account.money_amount = FFaker::Lorem.word
      expect(account).to_not be_valid
      expect(account.errors.messages[:money_amount]).to include('is not a number')
    end
    it 'is invalid if account number is less than 0.0' do
      account.money_amount = -FFaker::Random.rand(0...2000)
      expect(account).to_not be_valid
      expect(account.errors.messages[:money_amount]).to include('must be greater than or equal to 0.0')
    end
  end

  context 'active invalid entries' do
    it 'is invalid if active is nil' do
      account.active = nil
      expect(account).to_not be_valid
    end
  end

  context 'name invalid entries' do
    it 'is invalid if has no name' do
      account.name = nil
      expect(account).to_not be_valid
      expect(account.errors.messages[:name]).to include("can't be blank")
    end
    it 'is invalid if name length is less than 3' do
      account.name = FFaker::Lorem.characters(2)
      expect(account).to_not be_valid
      expect(account.errors.messages[:name]).to include('is too short (minimum is 3 characters)')
    end
    it 'is invalid if name length is grater than 50' do
      account.name = FFaker::Lorem.characters(60)
      expect(account).to_not be_valid
      expect(account.errors.messages[:name]).to include('is too long (maximum is 50 characters)')
    end
  end

  context 'email invalid entries' do
    it 'is invalid if has no email' do
      account.email = nil
      expect(account).to_not be_valid
      expect(account.errors.messages[:email]).to include("can't be blank")
    end

    it 'is invalid if email format is wrong' do
      account.email = 123456
      expect(account).to_not be_valid
      expect(account.errors.messages[:email]).to match_array(['invalid email format'])
      account.email = '@ASse.asas'
      expect(account).to_not be_valid
      expect(account.errors.messages[:email]).to match_array(['invalid email format'])
    end

  end
  

  context 'valid entries' do
    it 'is valid if has no errors' do
      expect(account).to be_valid
      expect(account.errors.messages).to match({})
    end

    it 'is valid if save and has no errors' do
      account.password = FFaker::Internet.password(6, 16)
      account.password_confirmation = account.password
      account.save
      expect(account).to be_valid
      expect(account.errors.messages).to match({})
    end
  end

end
