require "test_helper"

class NeighboursTest < ActionDispatch::IntegrationTest
  test "adding and removing neighbours" do
    %w[alex sasha].each { create_place(it) }
    sign_up "matvey"

    post "/api/my/neighbours", params: { username: "alex", label: "друг" }, as: :json
    assert_response :created
    post "/api/my/neighbours", params: { username: "sasha" }, as: :json
    post "/api/my/neighbours", params: { username: "alex" }, as: :json
    assert_response :created

    put "/api/my/neighbours/order", params: { usernames: %w[sasha alex] }, as: :json
    get "/api/places/matvey", as: :json
    neighbours = json["blocks"].find { it["kind"] == "neighbours" }
    assert_equal %w[sasha alex], neighbours.dig("content", "items").map { it["username"] }

    get "/api/places/alex", as: :json
    assert json["neighbour"]
    assert_equal 1, json["neighbour_of_count"]

    delete "/api/my/neighbours/alex", as: :json
    assert_response :no_content
    get "/api/places/alex", as: :json
    assert_not json["neighbour"]
  end

  test "neighbours are not mutual and you can't be your own neighbour" do
    create_place "kate"
    sign_up "matvey"
    post "/api/my/neighbours", params: { username: "matvey" }, as: :json
    assert_response :unprocessable_content

    post "/api/my/neighbours", params: { username: "kate" }, as: :json
    assert_equal 0, Place.find_by!(username: "kate").neighbourships.count

    get "/api/my/neighbours", as: :json
    assert_equal [ "kate" ], json["items"].map { it["username"] }
  end
end
