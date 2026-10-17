require "test_helper"

class ReviewerTest < ActiveSupport::TestCase
  test "a reviewer can be saved with a normalized email" do
    reviewer = Reviewer.new(name: "Taylor", email: "  TAYLOR@example.test  ")
    assert reviewer.save
    assert_equal "taylor@example.test", reviewer.reload.email
  end

  test "an unused reviewer can be deleted" do
    assert_difference("Reviewer.count", -1) { reviewers(:unused).destroy! }
  end

  test "duplicate email is rejected regardless of case" do
    reviewer = Reviewer.new(name: "Another Alex", email: "ALEX@example.test")
    assert_not reviewer.save
    assert reviewer.errors[:email].any?
  end

  test "a reviewer with decisions cannot be deleted" do
    reviewer = reviewers(:one)
    assert_no_difference("Reviewer.count") { assert_not reviewer.destroy }
    assert reviewer.errors[:base].any?
    assert Decision.exists?(decisions(:one).id)
  end

  test "name and valid email are required" do
    reviewer = Reviewer.new(email: "invalid")
    assert_not reviewer.valid?
    assert reviewer.errors[:name].any?
    assert reviewer.errors[:email].any?
  end
end
