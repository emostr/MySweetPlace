class ApplicationSerializer
  include Rails.application.routes.url_helpers

  def self.call(...) = new(...).call

  private
    def file_url(attachment)
      attachment.attached? ? rails_storage_proxy_path(attachment, only_path: true) : nil
    end

    def upload_json(upload)
      { id: upload.id, url: file_url(upload.file), width: upload.width, height: upload.height }
    end
end
