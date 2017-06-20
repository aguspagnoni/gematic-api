class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from ActionController::ParameterMissing, with: :render_nothing_bad_req
  rescue_from ActiveRecord::RecordNotFound, with: :render_nothing_not_found

  def render_nothing_bad_req
    render nothing: true, status: :bad_request
  end

  def render_nothing_not_found
    render nothing: true, status: :not_found
  end
end
