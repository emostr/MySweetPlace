require "test_helper"

class AuthTest < ActionDispatch::IntegrationTest
  test "sign up creates a place with default blocks and signs in" do
    sign_up "matvey"

    get "/api/me", as: :json
    assert_equal "matvey", json.dig("place", "username")
    assert_equal Place::DEFAULT_BLOCKS, Place.find_by!(username: "matvey").blocks.map(&:kind)
  end

  test "sign up reports errors for every field" do
    create_place "taken"
    post "/api/registration", params: { email_address: "nope", password: "123", username: "taken" }, as: :json

    assert_response :unprocessable_content
    assert_equal %w[email_address password username].sort, json["fields"].keys.sort
  end

  test "reserved and malformed usernames are rejected" do
    %w[admin random a -dash with.dot].each do |username|
      post "/api/registration", params: { email_address: "#{SecureRandom.hex(4)}@example.com", password: "password123", username: }, as: :json
      assert_response :unprocessable_content, username
    end
  end

  test "errors are localized" do
    post "/api/session", params: { email_address: "who@example.com", password: "wrong" }, headers: { "Accept-Language" => "en-US,en;q=0.9" }, as: :json
    assert_response :unauthorized
    assert_equal "Wrong email or password", json["message"]

    post "/api/session", params: { email_address: "who@example.com", password: "wrong" }, as: :json
    assert_equal "Неверная почта или пароль", json["message"]
  end

  test "sign in and sign out" do
    user = sign_up "kate"
    sign_out
    get "/api/me", as: :json
    assert_nil json["user"]

    sign_in user.email_address
    get "/api/me", as: :json
    assert_equal user.id, json.dig("user", "id")
  end

  test "changing password needs the current one" do
    sign_up "alex"
    patch "/api/me", params: { password: "newpassword1", current_password: "wrong" }, as: :json
    assert_response :unprocessable_content
    assert json["fields"].key?("current_password")

    patch "/api/me", params: { password: "newpassword1", current_password: "password123" }, as: :json
    assert_response :success
  end

  test "requests from foreign origins are rejected" do
    post "/api/session", params: { email_address: "x@example.com", password: "x" }, headers: { "Origin" => "https://evil.example" }, as: :json
    assert_response :forbidden
  end

  test "password reset" do
    user = sign_up "sasha"
    sign_out

    assert_enqueued_emails 1 do
      post "/api/password_resets", params: { email_address: "SASHA@example.com" }, as: :json
    end
    assert_response :accepted

    patch "/api/password_resets/#{user.password_reset_token}", params: { password: "brandnew123" }, as: :json
    assert_response :no_content
    sign_in user.email_address, password: "brandnew123"

    patch "/api/password_resets/garbage", params: { password: "brandnew123" }, as: :json
    assert_response :unprocessable_content
  end

  test "deleting the account" do
    sign_up "gone"
    delete "/api/me", params: { password: "password123" }, as: :json
    assert_response :no_content
    assert_nil Place.find_by(username: "gone")
  end
end
