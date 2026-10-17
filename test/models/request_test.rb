require "test_helper"

class RequestTest < ActiveSupport::TestCase
  test "a complete request can be saved" do
    request = Request.new(title: "Desk", description: "An adjustable desk", requester_email: "sam@example.test")
    assert request.save
  end

  test "a request exposes its decisions and their reviewers" do
    assert_includes requests(:one).decisions, decisions(:one)
    assert_equal reviewers(:one), requests(:one).decisions.first.reviewer
  end

  test "missing title and malformed email prevent saving" do
    request = Request.new(description: "A desk", requester_email: "invalid")
    assert_not request.save
    assert request.errors[:title].any?
    assert request.errors[:requester_email].any?
  end

  test "deleting a request also deletes its decisions" do
    assert_difference("Decision.count", -1) { requests(:one).destroy! }
  end
end
