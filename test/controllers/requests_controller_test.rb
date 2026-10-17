require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # IntegrationTest uses @request internally for the HTTP request object.
    # Give our domain record a distinct name so HTTP calls cannot overwrite it.
    @approval_request = requests(:one)
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "home page lists requests" do
    get root_url
    assert_response :success
    assert_select "a[href=?]", request_path(@approval_request)
  end

  test "invalid request re-renders the form with errors and entered values" do
    assert_no_difference("Request.count") do
      post requests_url, params: { request: { title: "", description: "Keep this text", requester_email: "invalid" } }
    end
    assert_response :unprocessable_content
    assert_select "textarea", "Keep this text"
    assert_select "li", /Title can't be blank/
  end

  test "request detail includes decision outcome and reviewer" do
    get request_url(@approval_request)
    assert_select "h3", "Approved by Alex Reviewer"
    assert_select "a[href=?]", new_decision_path(request_id: @approval_request.id)
  end

  test "unknown request returns not found" do
    get request_url(id: -1)
    assert_response :not_found
  end

  test "should get new" do
    get new_request_url
    assert_response :success
  end

  test "should create request" do
    assert_difference("Request.count") do
      post requests_url, params: { request: { description: @approval_request.description, requester_email: @approval_request.requester_email, title: @approval_request.title } }
    end

    assert_redirected_to request_url(Request.last)
  end

  test "should show request" do
    get request_url(@approval_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_request_url(@approval_request)
    assert_response :success
  end

  test "should update request" do
    patch request_url(@approval_request), params: { request: { description: @approval_request.description, requester_email: @approval_request.requester_email, title: @approval_request.title } }
    assert_redirected_to request_url(@approval_request)
  end

  test "should destroy request" do
    assert_difference("Request.count", -1) do
      delete request_url(@approval_request)
    end

    assert_redirected_to requests_url
  end
end
