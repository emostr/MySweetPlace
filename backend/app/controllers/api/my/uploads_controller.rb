class Api::My::UploadsController < Api::My::BaseController
  rate_limit to: 120, within: 10.minutes, only: :create, with: :too_many_requests

  def create
    upload = @place.uploads.create!(
      purpose: params[:purpose].to_s,
      width: params[:width].presence,
      height: params[:height].presence,
      file: params.require(:file)
    )
    render json: { upload: UploadSerializer.call(upload) }, status: :created
  end

  def destroy
    @place.uploads.find(params[:id]).destroy!
    head :no_content
  end
end
