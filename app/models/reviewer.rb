class Reviewer < ApplicationRecord
  # This is an address-book entry, not a login account. Authentication is a later
  # concern. Restrict deletion when decisions refer to this reviewer so those
  # decisions never lose their author; the controller displays the resulting error.
  has_many :decisions, dependent: :restrict_with_error

  # Normalize before validation so Alice@example.com and alice@example.com cannot
  # become separate reviewers. The unique database index also protects concurrent writes.
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
