require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:question).optional }
  it { should belong_to(:answer).optional }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
end
