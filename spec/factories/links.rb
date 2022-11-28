FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://google.ru" }
  end

  trait :valid_gist do
    url { 'https://gist.github.com/Mr-Slavka/77ab58aa336e5229098af7df33230dbb' }
  end

  trait :invalid_gist do
    url { 'https://gist.github.com/Mr-Slavka/' }
  end
end
