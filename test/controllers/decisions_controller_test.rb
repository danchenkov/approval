require "test_helper"

class DecisionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @decision = decisions(:one)
  end

  test "should get index" do
    get decisions_url
    assert_response :success
  end

  test "should get new" do
    get new_decision_url
    assert_response :success
  end

  test "should create decision" do
    assert_difference("Decision.count") do
      post decisions_url, params: { decision: { comment: @decision.comment, outcome: @decision.outcome, request_id: @decision.request_id, reviewer_id: @decision.reviewer_id } }
    end

    assert_redirected_to decision_url(Decision.last)
  end

  test "should show decision" do
    get decision_url(@decision)
    assert_response :success
  end

  test "should get edit" do
    get edit_decision_url(@decision)
    assert_response :success
  end

  test "should update decision" do
    patch decision_url(@decision), params: { decision: { comment: @decision.comment, outcome: @decision.outcome, request_id: @decision.request_id, reviewer_id: @decision.reviewer_id } }
    assert_redirected_to decision_url(@decision)
  end

  test "should destroy decision" do
    assert_difference("Decision.count", -1) do
      delete decision_url(@decision)
    end

    assert_redirected_to decisions_url
  end

  test "request detail link preselects the request in the decision form" do
    get new_decision_url(request_id: requests(:one).id)
    assert_response :success
    assert_select "select[name='decision[request_id]'] option[selected][value='#{requests(:one).id}']"
    assert_select "select[name='decision[reviewer_id]'] option", text: "Alex Reviewer"
  end

  test "invalid outcome re-renders rather than creating a decision" do
    assert_no_difference("Decision.count") do
      post decisions_url, params: { decision: { request_id: requests(:one).id, reviewer_id: reviewers(:one).id, outcome: "maybe" } }
    end
    assert_response :unprocessable_content
    assert_select "li", /Outcome is not included/
  end

  test "invalid update preserves the stored decision" do
    patch decision_url(@decision), params: { decision: { outcome: "maybe" } }
    assert_response :unprocessable_content
    assert_equal "approved", @decision.reload.outcome
  end
end
