FactoryGirl.define do
  sample_login = ['jack', 'lucy', 'dave', 'lily', 'john', 'beth'].sample
  sequence(:login) { |n| "#{sample_login}#{n}" }
  sequence(:email) { |n| "#{sample_login}#{n}@19wu.org".downcase }

  factory :user do
    login
    email
    password ['DJX5nvyX', 'GG83Sr4{', '_pW.2P*8', 'MH^IN3B_'].sample

    association :invitation, factory: [:invitation, :activated]

    trait :confirmed do
      confirmed_at '2013-01-01'
    end

    trait :admin do
      before(:create) do |user|
        user.add_role :admin
      end
    end
    
    trait :internal_test_not_approved do
      before(:create) do |user|
        user.invitation.activated = false
      end
    end

    trait :internal_test_approved do
      before(:create) do |user|
        user.invitation.code = Digest::MD5.hexdigest(user.email + Time.now.to_s)
        user.invitation.activated = false
      end
    end

    trait :internal_test_init do
      after(:create) do |user|
        user.invitation.destroy
        user.invitation = nil
      end
    end

  end
end
