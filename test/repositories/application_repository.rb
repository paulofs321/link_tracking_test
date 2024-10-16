require "test_helper"

class ApplicationRepositoryTest < ActiveSupport::TestCase
  setup do
    @repository = ApplicationRepository.new(LinkClick)
    @test_record = LinkClick.create!(url: "http://example.com", referrer: "http://referrer.com", ip_address: "127.0.0.1")
  end

  teardown do
    LinkClick.delete_all
  end

  test "all returns all records" do
    assert_equal 1, @repository.class.all.count
    assert_equal "http://example.com", @repository.class.all.first.url
  end

  test "find returns the record if found" do
    found_record = @repository.class.find(@test_record.id)
    assert_equal @test_record, found_record
  end

  test "find returns nil if record not found" do
    assert_nil @repository.class.find(-1)
  end

  test "create with a single record" do
    new_record = @repository.class.create(url: "http://new.com", referrer: "http://newreferrer.com", ip_address: "127.0.0.2")
    assert_equal "http://new.com", new_record.url
    assert_equal 2, @repository.class.all.count
  end

  test "create with multiple records" do
    records = @repository.class.create([
      { url: "http://record1.com", referrer: "http://referrer1.com", ip_address: "127.0.0.3" },
      { url: "http://record2.com", referrer: "http://referrer2.com", ip_address: "127.0.0.4" }
    ])
    assert_equal 2, records.size
    assert_equal 3, @repository.class.all.count # including the original test record
  end

  test "update modifies the record" do
    updated_record = @repository.class.update(@test_record.id, url: "http://updated.com")
    assert_equal "http://updated.com", updated_record.url
  end

  test "update returns nil if record not found" do
    assert_nil @repository.class.update(-1, url: "http://doesnotexist.com")
  end

  test "destroy removes the record" do
    assert_difference("LinkClick.count", -1) do
      @repository.class.destroy(@test_record.id)
    end
  end

  test "generate_id calls the tokenizer" do
    # Assuming Helpers::Tokenizer has been defined and works correctly
    Helpers::Tokenizer.stub(:generate, "generated_id") do
      id = @repository.class.generate_id
      assert_equal "generated_id", id
    end
  end
end
