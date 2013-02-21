# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    code nil
    activated false
  end

  trait :activated do
    activated true
  end
  
end
