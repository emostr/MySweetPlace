class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ErrorHandling
  include Localization
  include OriginCheck
  include Authentication
end
