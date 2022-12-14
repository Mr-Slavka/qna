FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { nil }
    user



    trait :answer_files do
      after :create do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end

    trait :invalid_answer do
      body { nil }
    end
  end
end
