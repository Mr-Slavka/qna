FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { Question.create!(title: "Question", body: "Question body") }

    trait :invalid do
      body { nil }
    end
  end
end
