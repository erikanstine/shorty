class Link < ApplicationRecord
  # target_url
  validates :target_url, presence: true,
                         format: { with: %r{\Ahttps?://\S+\z}i, message: 'must start with https:// or http://' }

  # code
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  before_validation :ensure_code, on: :create

  scope :active, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

  def active?
    expires_at.nil? || expires_at.future?
  end

  def increment_clicks!(by: 1)
    # self.class.increment_counter(:clicks_count, id, touch: true) if by == 1
    self.class.update_counters(id, clicks_count: by)
    reload
    clicks_count
  end

  def self.generate_unique_code(length = 8)
    loop do
      candidate = SecureRandom.alphanumeric(length).downcase
      break candidate unless exists?(code: candidate)
    end
  end

  private

  def ensure_code
    self.code ||= self.class.generate_unique_code
  end
end
