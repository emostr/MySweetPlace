require "test_helper"
require "rake"

class UploadsCleanupTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks if Rake::Task.tasks.none? { it.name == "uploads:cleanup" }
    Rake::Task["uploads:cleanup"].reenable
  end

  test "removes only old uploads that nothing references" do
    user = User.create!(email_address: "matvey@example.com", password: "password123")
    place = Place.create!(user:, username: "matvey")
    file = -> { Rack::Test::UploadedFile.new(file_fixture("pixel.png"), "image/png") }

    used = place.uploads.create!(purpose: "photo", file: file.call, created_at: 2.days.ago)
    orphan = place.uploads.create!(purpose: "photo", file: file.call, created_at: 2.days.ago)
    fresh = place.uploads.create!(purpose: "photo", file: file.call)
    note_image = place.uploads.create!(purpose: "note", file: file.call, created_at: 2.days.ago)

    photos = place.blocks.new(kind: "photos", position: 20)
    photos.assign_data(items: [ { image_id: used.id } ])
    photos.save!
    place.notes.create!(body: "", image_ids: [ note_image.id ])

    assert_output(/Removed 1 unused uploads/) { Rake::Task["uploads:cleanup"].invoke }
    assert Upload.exists?(used.id)
    assert Upload.exists?(fresh.id)
    assert Upload.exists?(note_image.id)
    assert_not Upload.exists?(orphan.id)
  end
end
