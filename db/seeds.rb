# Seeds are optional example data for exploring the UI (fixtures are for tests).
# find_or_create_by! reuses existing demo rows when you run db:seed again.
# The bang (!) raises if validation fails rather than silently skipping a row.
reviewer = Reviewer.find_or_create_by!(email: "alex@example.test") do |record|
  record.name = "Alex Reviewer"
end

request = Request.find_or_create_by!(title: "Replace the team laptop", requester_email: "sam@example.test") do |record|
  record.description = "The current laptop no longer starts. Requesting a replacement for development work."
end

# Seeds write models directly: loading sample data should not send notifications.
Decision.find_or_create_by!(request: request, reviewer: reviewer, outcome: "approved") do |record|
  record.comment = "Approved: replacement is within the equipment budget."
end
