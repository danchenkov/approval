require "test_helper"

class SubmitRequestTest < ActiveSupport::TestCase
  setup do
    # Keep this fake's instance so we can inspect deliveries without sending mail.
    # Each test starts with a fresh array and an isolated database transaction.
    @notifier = FakeNotifier.new
    @service = SubmitRequest.new(notifier: @notifier)
    @attributes = { title: "Keyboard", description: "Replace a broken keyboard", requester_email: "sam@example.test" }
  end

  test "submission saves a request and records one fake notification" do
    request = nil
    assert_difference("Request.count", 1) { request = @service.call(@attributes) }
    assert request.persisted?
    assert_equal [ "[Fake notification] Request ##{request.id} created" ], @notifier.deliveries
  end

  test "separate submissions each receive a notification" do
    first = @service.call(@attributes)
    second = @service.call(@attributes.merge(title: "Mouse"))
    assert_not_equal first.id, second.id
    assert_equal 2, @notifier.deliveries.size
  end

  test "invalid input neither saves nor notifies and retains errors" do
    request = nil
    assert_no_difference("Request.count") { request = @service.call(@attributes.merge(title: "")) }
    assert_not request.persisted?
    assert request.errors[:title].any?
    assert_empty @notifier.deliveries
  end
end
