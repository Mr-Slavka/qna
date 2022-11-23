class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links

  belongs_to :user

  validates :title, :body, presence: true
end
