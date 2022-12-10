class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many_attached :files
  has_one :reward, dependent: :destroy


  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  belongs_to :user

  validates :title, :body, presence: true
end
