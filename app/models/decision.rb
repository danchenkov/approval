class Decision < ApplicationRecord
  # These associations use request_id and reviewer_id foreign keys. Rails also
  # validates that both referenced records exist (belongs_to is required by default).
  belongs_to :request
  belongs_to :reviewer

  # Keep the initial vocabulary explicit and small. A constant freezes the list
  # shared by validation and the form; this is not a workflow/state machine yet.
  OUTCOMES = %w[approved rejected].freeze
  validates :outcome, inclusion: { in: OUTCOMES }
end
