ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
  end
end

class ActionDispatch::IntegrationTest
  def json = response.parsed_body

  def sign_up(username, email: "#{username}@example.com", password: "password123")
    post "/api/registration", params: { email_address: email, password:, username: }, as: :json
    assert_response :created
    User.find_by!(email_address: email)
  end

  def sign_in(email, password: "password123")
    post "/api/session", params: { email_address: email, password: }, as: :json
    assert_response :success
  end

  def sign_out
    delete "/api/session", as: :json
  end

  def create_place(username, **attributes)
    user = User.create!(email_address: "#{username}@example.com", password: "password123")
    Place.create!(user:, username:, **attributes)
  end

  def upload_image(purpose: "photo")
    post "/api/my/uploads", params: { purpose:, width: 2, height: 2, file: fixture_file_upload("pixel.png", "image/png") }
    assert_response :created
    json.dig("upload", "id")
  end
end
