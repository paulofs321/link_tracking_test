require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should respond with 429 for rate_limit_exceeded" do
    get rate_limit_exceeded_url
    assert_response :too_many_requests
  end
end
