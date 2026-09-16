namespace :uploads do
  desc "Remove uploads that are no longer used by any block, theme or note"
  task cleanup: :environment do
    removed = 0
    Place.find_each do |place|
      orphans = place.uploads.where(created_at: ...1.day.ago).where.not(id: place.upload_ids_in_use)
      orphans.find_each do |upload|
        upload.destroy
        removed += 1
      end
    end
    puts "Removed #{removed} unused uploads"
  end
end
