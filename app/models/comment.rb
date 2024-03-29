class Comment < ApplicationRecord
  belongs_to :question, optional: true, touch: true
  belongs_to :answer, optional: true, touch: true
  belongs_to :user

  validates :body, presence: true
end
