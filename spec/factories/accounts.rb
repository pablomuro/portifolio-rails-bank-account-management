FactoryBot.define do
  factory :account do
    account_number { FFaker::String.from_regexp(/[0-9]{4}-[0-9]{1}/) }
    password { '123456' }
    password_confirmation { '123456' }
    money_amount { FFaker::Random.rand(0...2000) }
    active { true }
  end

  factory :invalid_account, class: 'Account' do
    account_number { FFaker::String.from_regexp(/[A-Z-a-z-1-9-]{6}/) }
    password { FFaker::Internet.password(1, 10) }
    password_confirmation { FFaker::Internet.password(10, 16) }
    money_amount { FFaker::Random.rand(0...2000) * -1 }
    active { 'falsy' }
  end
end
