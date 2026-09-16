require "test_helper"

class NotesTest < ActionDispatch::IntegrationTest
  test "writing notes with markdown and images" do
    sign_up "matvey"
    image = upload_image(purpose: "note")

    post "/api/my/notes", params: { body: "наконец нормально настроил **nginx**\nненавижу nginx", image_ids: [ image ] }, as: :json
    assert_response :created
    note = json["note"]
    assert_includes note["body_html"], "<strong>nginx</strong>"
    assert_equal 1, note["images"].size

    patch "/api/my/notes/#{note["id"]}", params: { image_ids: [] }, as: :json
    assert_response :success
    assert_not Upload.exists?(image)

    post "/api/my/notes", params: { body: "" }, as: :json
    assert_response :unprocessable_content
  end

  test "notes feed pagination and single note page" do
    user = sign_up "matvey"
    25.times { user.place.notes.create!(body: "запись #{it}") }
    sign_out

    get "/api/places/matvey/notes", as: :json
    assert_equal 20, json["items"].size
    assert json["has_more"]

    get "/api/places/matvey/notes", params: { before: json["items"].last["id"] }
    assert_equal 5, json["items"].size

    note = user.place.notes.first
    get "/api/places/matvey/notes/#{note.id}", as: :json
    assert_equal note.body, json.dig("note", "body")
    assert_equal "matvey", json.dig("place", "username")
    assert_empty json.dig("place", "blocks")
  end

  test "notes are private when the block is hidden" do
    user = sign_up "matvey"
    user.place.blocks.find_by!(kind: "notes").update!(visible: false)
    user.place.notes.create!(body: "секрет")

    get "/api/places/matvey/notes", as: :json
    assert_response :success

    sign_out
    get "/api/places/matvey/notes", as: :json
    assert_response :not_found
  end

  test "home shows fresh notes and places" do
    user = sign_up "matvey"
    user.place.notes.create!(body: "сегодня первый снег :)")
    sign_out

    get "/api/home", as: :json
    assert_equal "сегодня первый снег :)", json.dig("notes", 0, "body")
    assert_equal "matvey", json.dig("notes", 0, "place", "username")
    assert_equal [ "matvey" ], json["places"].map { it["username"] }
  end
end
