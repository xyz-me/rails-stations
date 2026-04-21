FactoryBot.define do
  factory :screen do
    association :schedule
    association :room
  end
end
