require "test_helper"
require "minitest/mock"

class LinkClicksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @valid_params = {
      link_click: {
        url: "http://example.com",
        anchor_text: "Example",
        referrer: "http://referrer.com",
        user_agent: "Mozilla/5.0"
      }
    }

    @json_params = {
      _json: [
        {
          url: "http://example.com",
          anchor_text: "Example",
          referrer: "http://referrer.com",
          user_agent: "Mozilla/5.0"
        }
      ]
    }
  end

  test "should enqueue LinkClickJob with correct params when creating link click" do
    assert_enqueued_with(job: LinkClickJob) do
      post link_clicks_url, params: @valid_params
    end

    assert_response :success
  end

  test "should enqueue LinkcClickJob with json params when creating link click" do
    assert_enqueued_with(job: LinkClickJob) do
      post link_clicks_url, params: @json_params
    end

    assert_response :success
  end
end
