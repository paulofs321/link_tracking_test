require "test_helper"

class LinkClickTest < ActiveSupport::TestCase
  setup do
    @valid_attributes = {
      url: "http://example.com",
      referrer: "http://referrer.com",
      ip_address: "127.0.0.1"
    }
  end

  test "should require a URL" do
    link_click = LinkClick.new(@valid_attributes.except(:url))
    assert_not link_click.valid?
    assert_includes link_click.errors[:url], "can't be blank"
  end

  test "should validate URL format" do
    invalid_urls = [ "invalid_url", "www.another_invalid_url.com" ]
    invalid_urls.each do |invalid_url|
      link_click = LinkClick.new({ url: invalid_url })
      assert_not link_click.valid?
      assert_includes link_click.errors[:url], "is invalid"
    end
  end

  test "should validate referrer format" do
    link_click = LinkClick.new(@valid_attributes.merge(referrer: "invalid_referrer"))
    assert_not link_click.valid?
    assert_includes link_click.errors[:referrer], "is invalid"
  end

  test "should validate IP address format" do
    invalid_ips = [ "invalid_ip", "127.123.1." ]
    invalid_ips.each do |invalid_ip|
      link_click = LinkClick.new({ url: @valid_attributes[:url], referrer: "", ip_address: invalid_ip })
      assert_not link_click.valid?
      assert_includes link_click.errors[:ip_address], "is invalid"
    end
  end
end
