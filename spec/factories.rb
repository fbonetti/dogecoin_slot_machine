FactoryGirl.define do
  factory :user do
    key "271c8e770081ab527b8f04d338d046d2"
    deposit_address  "D7Z8W9Gszbme8gU3kWHkdtK1yrUtzuWvG7"
  end

  factory :promotion do
    code "reddit"
    description "test promo code"
    amount 200
    limit 5
  end

  factory :promotion_redemption do
    user_id 1
    promotion_id 1
  end
end