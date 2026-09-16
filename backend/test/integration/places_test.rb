require "test_helper"

class PlacesTest < ActionDispatch::IntegrationTest
  test "public place hides hidden blocks, owner sees them" do
    user = sign_up "matvey"
    place = user.place
    place.blocks.find_by!(kind: "projects").update!(visible: false)

    get "/api/places/matvey", as: :json
    assert json["owner"]
    assert_includes json["blocks"].map { it["kind"] }, "projects"

    sign_out
    get "/api/places/MATVEY", as: :json
    assert_response :success
    assert_not json["owner"]
    assert_not_includes json["blocks"].map { it["kind"] }, "projects"
  end

  test "unknown and suspended places are not found" do
    get "/api/places/nobody", as: :json
    assert_response :not_found

    create_place "banned", suspended_at: Time.current
    get "/api/places/banned", as: :json
    assert_response :not_found
  end

  test "update profile and theme" do
    sign_up "matvey"
    patch "/api/my/place", params: {
      profile: { name: { ru: "Матвей Серов", en: "Matvei Serov" }, location: { ru: "Пенза, Россия", en: "Penza, Russia" }, junk: "x" },
      theme: { preset: "night", colors: { accent: "#F0A" }, font: "pt-serif" }
    }, as: :json

    assert_response :success
    place = json["place"]
    assert_equal "Matvei Serov", place.dig("profile", "name", "en")
    assert_nil place.dig("profile", "junk")
    assert_equal "#ff00aa", place.dig("theme", "colors", "accent")
    assert_equal "#ffffff", place.dig("theme", "colors", "surface")
  end

  test "invalid theme returns field errors" do
    sign_up "matvey"
    patch "/api/my/place", params: { theme: { font: "comic-sans", background: { type: "image" } } }, as: :json

    assert_response :unprocessable_content
    assert json["fields"].key?("theme.font")
    assert json["fields"].key?("theme.background.image_id")
  end

  test "blocks: add, update, reorder, delete" do
    sign_up "matvey"

    post "/api/my/blocks", params: { kind: "stack", data: { items: [ { slug: "ruby" }, { name: "1С", color: "#ffcc00" } ] } }, as: :json
    assert_response :created
    block_id = json["block_id"]
    stack = json.dig("place", "blocks").find { it["id"] == block_id }
    assert_equal 2, stack.dig("data", "items").size

    post "/api/my/blocks", params: { kind: "intro" }, as: :json
    assert_response :unprocessable_content

    patch "/api/my/blocks/#{block_id}", params: { style: { variant: "icons", width: "half" }, title: { ru: "Мой стек" } }, as: :json
    assert_response :success

    ids = json.dig("place", "blocks").map { it["id"] }.reverse
    put "/api/my/blocks/order", params: { ids: }, as: :json
    assert_equal ids, json.dig("place", "blocks").map { it["id"] }

    delete "/api/my/blocks/#{block_id}", as: :json
    assert_not_includes json.dig("place", "blocks").map { it["id"] }, block_id
  end

  test "block data is validated" do
    sign_up "matvey"
    links = Place.find_by!(username: "matvey").blocks.find_by!(kind: "links")

    patch "/api/my/blocks/#{links.id}", params: { data: { items: [ { title: "x", url: "javascript:alert(1)" } ] } }, as: :json
    assert_response :unprocessable_content
    assert json["fields"].key?("data.items.0.url")
  end

  test "blocks can reference only own uploads" do
    sign_up "kate"
    kate_upload = upload_image
    sign_out

    sign_up "matvey"
    post "/api/my/blocks", params: { kind: "photos", data: { items: [ { image_id: kate_upload } ] } }, as: :json
    assert_response :unprocessable_content

    own = upload_image
    post "/api/my/blocks", params: { kind: "photos", data: { items: [ { image_id: own, caption: { ru: "снег" } } ] } }, as: :json
    assert_response :created
    assert json.dig("place", "uploads", own.to_s, "url").start_with?("/api/storage/")
  end

  test "interests are searchable" do
    sign_up "matvey"
    post "/api/my/blocks", params: { kind: "interests", data: { items: [ { label: "Музыка" }, { label: "nginx" } ] } }, as: :json
    sign_out
    create_place "empty"

    get "/api/places", params: { interest: "музыка" }
    assert_equal [ "matvey" ], json["items"].map { it["username"] }

    get "/api/interests", as: :json
    assert_includes json["items"].map { it["label"] }, "nginx"
  end

  test "random place skips empty places and the current one" do
    get "/api/places/random", as: :json
    assert_response :not_found

    %w[one two].each { create_place(it, content_updated_at: Time.current) }
    create_place "empty"

    10.times do
      get "/api/places/random", params: { except: "one" }
      assert_equal "two", json["username"]
    end
  end

  test "avatar upload accepts images only" do
    sign_up "matvey"

    put "/api/my/place/avatar", params: { file: fixture_file_upload("evil.svg", "image/png") }
    assert_response :unprocessable_content

    put "/api/my/place/avatar", params: { file: fixture_file_upload("pixel.png", "image/png") }
    assert_response :success
    assert json.dig("place", "avatar_url").present?
  end
end
