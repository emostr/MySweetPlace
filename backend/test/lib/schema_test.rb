require "test_helper"

class SchemaTest < ActiveSupport::TestCase
  S = Schema

  test "drops unknown keys and fills defaults" do
    result = S.cast(S.object(name: S.string(max: 10), count: S.integer(default: 3)), { "name" => " hi ", "evil" => 1 })
    assert result.valid?
    assert_equal({ "name" => "hi", "count" => 3 }, result.value)
  end

  test "strips control characters and newlines in single line strings" do
    assert_equal "a b c", S.cast(S.string(max: 20), "a#{0.chr}\nb\tc").value
    assert_equal "a\n\nb", S.cast(S.string(max: 20, multiline: true), "a\r\n\n\n\nb").value
  end

  test "reports errors with paths" do
    schema = S.object(items: S.array(max: 1, of: S.object({ url: S.url(required: true) }, id: true)))
    result = S.cast(schema, { items: [ { url: "javascript:alert(1)" }, { url: "https://ok.dev" } ] })
    assert_not result.valid?
    assert result.errors.key?("items")
    assert result.errors.key?("items.0.url")
    assert_equal 1, result.value["items"].size
  end

  test "keeps valid item ids and generates missing ones" do
    schema = S.array(max: 5, of: S.object({ title: S.string(max: 10) }, id: true))
    items = S.cast(schema, [ { id: "keep-me", title: "a" }, { id: "<bad>", title: "b" } ]).value
    assert_equal "keep-me", items[0]["id"]
    assert_match(/\A[A-Za-z0-9]{10}\z/, items[1]["id"])
  end

  test "normalizes colors, urls and dates" do
    assert_equal "#aabbcc", S.cast(S.color, "#ABC").value
    assert_equal "https://github.com/me", S.cast(S.url, "github.com/me").value
    assert_equal "mailto:me@example.com", S.cast(S.url(schemes: %w[https mailto]), "mailto:me@example.com").value
    assert_not S.cast(S.date(precision: :month), "2026-13").valid?
    assert S.cast(S.date, "2024-02-29").valid?
    assert_not S.cast(S.date, "2023-02-29").valid?
  end

  test "localized strings keep only filled locales" do
    assert_equal({ "ru" => "привет" }, S.cast(S.localized(max: 10), { ru: "привет", en: " ", de: "hallo" }).value)
    assert_not S.cast(S.localized(max: 10, required: true), {}).valid?
  end

  test "collects upload references" do
    result = S.cast(S.object(photos: S.array(max: 3, of: S.upload)), { photos: [ 1, "2", "x" ] })
    assert_equal [ 1, 2 ], result.upload_ids
    assert result.errors.key?("photos.2")
  end
end
