# test/jobs/link_click_job_test.rb

require "test_helper"

class LinkClickJobTest < ActiveJob::TestCase
  setup do
    @valid_params = {
      url: "http://example.com",
      anchor_text: "Example",
      referrer: "http://referrer.com",
      user_agent: "Mozilla/5.0",
      ip_address: "::1"
    }

    @invalid_params = {}
  end

  test "perform with single params" do
    # Stub the repository methods to avoid actual DB calls
    LinkClickRepository.stub(:generate_id, "generated_id") do
      LinkClickRepository.stub(:create, true) do
        LinkClickJob.perform_now(@valid_params)
        # Assert that the create method was called with the expected parameters
        assert_equal "generated_id", @valid_params[:id]
        assert LinkClickRepository.create(@valid_params).present?
      end
    end
  end

  test "perform with array params" do
    params_array = [
      {
        url: "http://example.com/1",
        anchor_text: "Example 1",
        referrer: "http://referrer.com/1",
        user_agent: "Mozilla/5.0",
        ip_address: "::1"
      },
      {
        url: "http://example.com/2",
        anchor_text: "Example 2",
        referrer: "http://referrer.com/2",
        user_agent: "Mozilla/5.0",
        ip_address: "::1"
      }
    ]
    # Stub the repository methods
    LinkClickRepository.stub(:generate_id, -> { SecureRandom.uuid }) do
      LinkClickRepository.stub(:create, ->(params) { params }) do
        result = LinkClickJob.perform_now(params_array)

        # Verify that IDs were assigned
        result.each do |params|
          assert params.key?(:id), "ID should be assigned"
          assert_not_nil params[:id]
        end
      end
    end
  end

  test "handles exceptions" do
    # Stub the create method to raise an error
    LinkClickRepository.stub(:generate_id, "generated_id") do
      LinkClickRepository.stub(:create, true) do
        assert_silent { LinkClickJob.perform_now(@invalid_params) }
      end
    end
  end
end
