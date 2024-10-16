require "test_helper"

class LinkClickRepositoryTest < ActiveSupport::TestCase
  setup do
    @link_click = LinkClick.create!(url: "http://example.com", referrer: "http://referrer.com", ip_address: "192.168.1.1")
    @link_click_2 = LinkClick.create!(url: "http://example.com/2", referrer: "", ip_address: "192.168.1.2")
  end

  teardown do
    Rails.cache.clear
    LinkClick.delete_all
  end

  test "clicks_over_time returns clicks grouped by date" do
    result = LinkClickRepository.clicks_over_time((Time.now - 1.day).to_s, Time.now.to_s)
    assert_equal 2, result.values.sum
    assert_equal 1, result.keys.count { |date| date.to_date == Date.today }
    assert_equal 1, result.keys.count { |date| date.to_date == Date.today - 1 }
  end

  test "clicks_per_link returns clicks grouped by URL" do
    result = LinkClickRepository.clicks_per_link
    assert_equal 2, result.values.sum
    assert result.key?("http://example.com")
    assert result.key?("http://example.com/2")
  end

  test "most_clicked_link returns the URL with the most clicks" do
    LinkClick.create!(url: "http://example.com", ip_address: "192.168.1.1")
    LinkClick.create!(url: "http://example.com", ip_address: "192.168.1.1")
    assert_equal "http://example.com", LinkClickRepository.most_clicked_link
  end

  test "most_clicked_link_count returns the number of clicks for the most clicked link" do
    LinkClick.create!(url: "http://example.com", ip_address: "192.168.1.1")
    LinkClick.create!(url: "http://example.com", ip_address: "192.168.1.1")
    assert_equal 3, LinkClickRepository.most_clicked_link_count
  end

  test "total_link_clicks returns the total count of link clicks" do
    result = LinkClickRepository.total_link_clicks
    assert_equal 2, result
  end

  test "clear_cache deletes the specified keys from the cache" do
    Rails.cache.write("some_key", "some_value")
    assert_equal "some_value", Rails.cache.read("some_key")

    LinkClickRepository.clear_cache([ "some_key" ])
    assert_nil Rails.cache.read("some_key")
  end

  test "clicks_over_time caches results" do
    LinkClickRepository.clicks_over_time
    assert_not_nil Rails.cache.read("clicks_over_time/#{Date.today}-#{Date.today.end_of_day}")
  end

  test "total_link_clicks caches results" do
    LinkClickRepository.total_link_clicks
    assert_not_nil Rails.cache.read("total_link_clicks/#{Date.today}-#{Date.today.end_of_day}")
  end
end
