class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :question, optional: true
  belongs_to :answer, optional: true

  validates :value, presence: true
  validates :user, presence: true

end
