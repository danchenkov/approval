class Request < ApplicationRecord
  # Active Record maps Request to the `requests` table. Each instance represents
  # one row; `save`, `update`, and `destroy` issue SQL on our behalf.
  # A request owns its decisions, so deleting it also deletes those records.
  has_many :decisions, dependent: :destroy

  # Validations run before a save. Invalid objects keep their entered values and
  # expose `errors`, which the form displays instead of writing a bad row.
  validates :title, :description, :requester_email, presence: true
  validates :requester_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
