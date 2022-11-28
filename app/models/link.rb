class Link < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :answer, optional: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp(%w[http https])

  def gist?
    URI.parse(url).host.include?('gist')
  end

  def gist_id
    URI.parse(url).path.split('/').last
  end
end
