require "test_helper"
require "minitest/mock"

class AdminControllerTest < ActionDispatch::IntegrationTest
  setup do
    @start_date = Date.today
    @end_date = Date.today
  end

  test "should get index and call repository methods" do
    mock_repo = Minitest::Mock.new

    mock_repo.expect :clicks_per_link, [ { "http://example.com" => 5 }, { "http://example2.com" => 1 } ]
    mock_repo.expect :total_link_clicks, 6
    mock_repo.expect :clicks_over_time, [ { @end_date => 6 } ]
    mock_repo.expect :most_clicked_link, "http://example.com"
    mock_repo.expect :most_clicked_link_count, 5

    stub_link_click_repository(mock_repo) do
      get admin_url, params: { start_date: @start_date, end_date: @end_date }

      assert_response :success
      assert_equal [ { "http://example.com" => 5 }, { "http://example2.com" => 1 } ], assigns(:clicks_per_link)
      assert_equal 6, assigns(:total_link_clicks)
      assert_equal [ { @end_date => 6 } ], assigns(:clicks_over_time)
      assert_equal "http://example.com", assigns(:most_clicked_link)
      assert_equal 5, assigns(:most_clicked_link_count)
    end

    mock_repo.verify
  end

  test "should handle missing parameters" do
    mock_repo = Minitest::Mock.new

    mock_repo.expect :clicks_per_link, [ { "http://example.com" => 10 }, { "http://example2.com" => 1 } ]
    mock_repo.expect :total_link_clicks, 11
    mock_repo.expect :clicks_over_time, [ { "2024-01-01" => 5 }, { "#{@end_date}" => 6 } ]
    mock_repo.expect :most_clicked_link, "http://example.com"
    mock_repo.expect :most_clicked_link_count, 6

    stub_link_click_repository(mock_repo) do
      get admin_url

      assert_response :success
      assert_equal [ { "http://example.com" => 10 }, { "http://example2.com" => 1 } ], assigns(:clicks_per_link)
      assert_equal 11, assigns(:total_link_clicks)
      assert_equal [ { "2024-01-01" => 5 }, { "#{@end_date}" => 6 } ], assigns(:clicks_over_time)
      assert_equal "http://example.com", assigns(:most_clicked_link)
      assert_equal 6, assigns(:most_clicked_link_count)
    end

    mock_repo.verify
  end
end

def stub_link_click_repository(mock_repo)
  LinkClickRepository.stub(:clicks_per_link, mock_repo.clicks_per_link) do
    LinkClickRepository.stub(:most_clicked_link, mock_repo.most_clicked_link) do
      LinkClickRepository.stub(:most_clicked_link_count, mock_repo.most_clicked_link_count) do
        LinkClickRepository.stub(:total_link_clicks, mock_repo.total_link_clicks) do
          LinkClickRepository.stub(:clicks_over_time, mock_repo.clicks_over_time) do
            yield
          end
        end
      end
    end
  end
end
