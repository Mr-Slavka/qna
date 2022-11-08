FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { Question.create!(title: "Question", body: "Question body") }
  end
end
