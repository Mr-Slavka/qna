require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:question).optional }
  it { should belong_to(:answer).optional }
  it { should belong_to(:user) }

  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:user) }
end
