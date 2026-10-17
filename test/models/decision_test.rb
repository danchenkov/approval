require "test_helper"

class DecisionTest < ActiveSupport::TestCase
  test "a reviewer can approve a request" do
    decision = Decision.new(request: requests(:one), reviewer: reviewers(:two), outcome: "approved")
    assert decision.save
  end

  test "a reviewer can reject a request with a comment" do
    decision = Decision.new(request: requests(:one), reviewer: reviewers(:two), outcome: "rejected", comment: "Over budget")
    assert decision.save
    assert_equal "Over budget", decision.reload.comment
  end

  test "unknown outcomes and missing associations are rejected" do
    decision = Decision.new(outcome: "maybe")
    assert_not decision.save
    assert decision.errors[:outcome].any?
    assert decision.errors[:request].any?
    assert decision.errors[:reviewer].any?
  end

  test "nonexistent foreign IDs do not produce an orphan decision" do
    decision = Decision.new(request_id: -1, reviewer_id: -1, outcome: "approved")
    assert_not decision.save
  end
end
