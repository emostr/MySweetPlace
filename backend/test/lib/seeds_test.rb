require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "initial seeds create only the mascot with its content" do
    load_seeds

    assert_equal [ "niki@example.com" ], User.pluck(:email_address)
    assert_equal [ "niki" ], Place.pluck(:username)
    niki = Place.find_by!(username: "niki")
    assert niki.avatar.attached?
    assert_equal "Ники", niki.display_name(:ru)
    assert_equal "lilac", niki.theme["preset"]
    assert_equal 8, niki.blocks.count
    assert_equal 4, niki.notes.count
    assert_includes Place.discoverable, niki
    assert_empty Neighbourship.all
    assert_empty GuestbookEntry.all
    assert niki.user.authenticate("password123")
  end

  test "repeated seeds preserve existing content and accounts" do
    load_seeds
    niki = Place.find_by!(username: "niki")
    niki.assign_profile(name: { ru: "Хранитель уюта" })
    niki.save!
    niki.user.update!(password: "changed-password")
    niki.notes.create!(body: "Новая запись")
    other = User.create!(email_address: "alex@example.com", password: "another-password")
    Place.create!(user: other, username: "alex")

    assert_no_difference [ "User.count", "Place.count", "Block.count", "Note.count", "ActiveStorage::Blob.count" ] do
      load_seeds
    end

    assert_equal "Хранитель уюта", niki.reload.display_name(:ru)
    assert niki.user.reload.authenticate("changed-password")
    assert niki.notes.exists?(body: "Новая запись")
    assert Place.exists?(username: "alex")
  end

  test "production seeds do not use the development password or print credentials" do
    output = load_seeds(environment: "production")

    assert_equal [ "niki" ], Place.pluck(:username)
    assert_not User.find_by!(email_address: "niki@example.com").authenticate("password123")
    assert_no_match(/password123|Development login/, output)
  end

  test "production accepts a configured mascot password only on creation" do
    output = load_seeds(environment: "production", password: "mascot-production-password")
    assert User.find_by!(email_address: "niki@example.com").authenticate("mascot-production-password")
    assert_no_match(/mascot-production-password/, output)

    load_seeds(environment: "production", password: "different-password")
    assert User.find_by!(email_address: "niki@example.com").authenticate("mascot-production-password")
  end

  test "a failed place creation does not leave a partial mascot account" do
    owner = User.create!(email_address: "owner@example.com", password: "owner-password")
    Place.create!(user: owner, username: "niki")

    assert_no_difference [ "User.count", "Place.count" ] do
      assert_raises(ActiveRecord::RecordInvalid) { load_seeds }
    end
    assert_not User.exists?(email_address: "niki@example.com")
  end

  private
    def load_seeds(environment: "test", password: nil)
      original_environment = Rails.env
      original_password = ENV["NIKI_PASSWORD"]
      Rails.env = environment
      ENV["NIKI_PASSWORD"] = password
      capture_io { load Rails.root.join("db/seeds.rb") }.first
    ensure
      Rails.env = original_environment
      ENV["NIKI_PASSWORD"] = original_password
    end
end
