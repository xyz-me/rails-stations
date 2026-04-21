FactoryBot.define do
  factory :room do
    association :site
    sequence(:screen_number) { |n| n }
  end
end
