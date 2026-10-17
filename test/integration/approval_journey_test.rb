require "test_helper"

# Integration tests exercise real routes, controllers, models, and rendered HTML
# together. No browser driver is needed for this server-rendered starter.
class ApprovalJourneyTest < ActionDispatch::IntegrationTest
  test "create a reviewer and request, record a decision, and see it on the request" do
    post reviewers_url, params: { reviewer: { name: "Jamie", email: "jamie@example.test" } }
    reviewer = Reviewer.find_by!(email: "jamie@example.test")
    assert_redirected_to reviewer_url(reviewer)

    post requests_url, params: { request: { title: "Monitor", description: "A larger screen", requester_email: "pat@example.test" } }
    approval_request = Request.find_by!(title: "Monitor")
    assert_redirected_to request_url(approval_request)
    follow_redirect!
    assert_select "p", "No decisions recorded yet."

    get new_decision_url(request_id: approval_request.id)
    assert_select "select[name='decision[request_id]'] option[selected][value='#{approval_request.id}']"

    post decisions_url, params: { decision: { request_id: approval_request.id, reviewer_id: reviewer.id, outcome: "approved", comment: "Within budget" } }
    assert_redirected_to decision_url(Decision.last)

    get request_url(approval_request)
    assert_select "h3", "Approved by Jamie"
    assert_select "p", "Within budget"
  end
end
