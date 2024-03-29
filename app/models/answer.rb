class Answer < ApplicationRecord
  include Votable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  after_create :email_notification

  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  private

  def email_notification
    NotificationJob.perform_later(self)
  end
end
