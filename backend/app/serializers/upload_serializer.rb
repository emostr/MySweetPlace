class UploadSerializer < ApplicationSerializer
  def initialize(upload)
    @upload = upload
  end

  def call = upload_json(@upload)
end
