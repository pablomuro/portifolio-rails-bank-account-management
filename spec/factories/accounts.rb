FactoryBot.define do
  factory :account do
    account_number { FFaker::String.from_regexp(/[0-9]{4}-[0-9]{1}/) }
    password { '123456' }
    password_confirmation { '123456' }
    money_amount { FFaker::Random.rand(0...2000) }
    active { true }
  end
end
