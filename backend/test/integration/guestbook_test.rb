require "test_helper"

class GuestbookTest < ActionDispatch::IntegrationTest
  setup do
    @owner = sign_up "matvey"
    @place = @owner.place
    @block = @place.guestbook_block
    sign_out
  end

  def configure(**data)
    @block.assign_data(@block.data.merge(data.stringify_keys))
    @block.save!
  end

  test "guests can write when the guestbook is open" do
    post "/api/places/matvey/guestbook", params: { author_name: "гость", body: "уютно тут :)" }, as: :json
    assert_response :created
    assert_equal "гость", json.dig("entry", "author", "name")

    get "/api/places/matvey", as: :json
    guestbook = json["blocks"].find { it["kind"] == "guestbook" }
    assert_equal "уютно тут :)", guestbook.dig("content", "items", 0, "body")
    assert guestbook.dig("content", "can_write")
  end

  test "members only and closed guestbooks" do
    configure(access: "members")
    post "/api/places/matvey/guestbook", params: { author_name: "гость", body: "привет" }, as: :json
    assert_response :forbidden
    assert_equal "guestbook_members_only", json["error"]

    sign_up "kate"
    post "/api/places/matvey/guestbook", params: { body: "классный проект!" }, as: :json
    assert_response :created
    assert_equal "kate", json.dig("entry", "author", "username")

    configure(access: "nobody")
    post "/api/places/matvey/guestbook", params: { body: "ещё" }, as: :json
    assert_equal "guestbook_closed", json["error"]
  end

  test "premoderated entries wait for the owner" do
    configure(premoderation: true)
    post "/api/places/matvey/guestbook", params: { author_name: "гость", body: "ждём" }, as: :json
    entry_id = json.dig("entry", "id")

    get "/api/places/matvey/guestbook", as: :json
    assert_empty json["items"]

    sign_in @owner.email_address
    get "/api/my/guestbook", params: { status: "pending" }
    assert_equal [ entry_id ], json["items"].map { it["id"] }

    patch "/api/my/guestbook/#{entry_id}", params: { status: "visible", pinned: true }, as: :json
    assert_response :success
    assert json.dig("entry", "pinned")
  end

  test "owner can hide and delete, authors can delete their own entries" do
    sign_up "kate"
    post "/api/places/matvey/guestbook", params: { body: "моё" }, as: :json
    entry_id = json.dig("entry", "id")
    delete "/api/places/matvey/guestbook/#{entry_id}", as: :json
    assert_response :no_content

    post "/api/places/matvey/guestbook", params: { body: "ещё моё" }, as: :json
    entry_id = json.dig("entry", "id")
    sign_out
    delete "/api/places/matvey/guestbook/#{entry_id}", as: :json
    assert_response :forbidden

    sign_in @owner.email_address
    patch "/api/my/guestbook/#{entry_id}", params: { status: "hidden" }, as: :json
    sign_out
    get "/api/places/matvey/guestbook", as: :json
    assert_empty json["items"]
  end

  test "honeypot silently drops bots and entries are validated" do
    post "/api/places/matvey/guestbook", params: { author_name: "bot", body: "spam", website: "http://spam" }, as: :json
    assert_response :created
    assert_equal 0, @place.guestbook_entries.count

    post "/api/places/matvey/guestbook", params: { author_name: "", body: "x" * 501 }, as: :json
    assert_response :unprocessable_content
    assert_equal %w[author_name body], json["fields"].keys.sort
  end
end
