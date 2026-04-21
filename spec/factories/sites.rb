FactoryBot.define do
  factory :site do
    sequence(:name) { |n| "劇場#{n}" }
  end
end
