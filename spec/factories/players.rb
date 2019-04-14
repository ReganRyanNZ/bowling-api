FactoryBot.define do
  factory :player do
    game
    name { Faker::Name.name }
  end
end