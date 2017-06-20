module ControllerHelper
  def add_authentication_header_for(id)
    request.headers.merge! authenticated_header(id)
  end

  def authenticated_header(entity)
    token = Knock::AuthToken.new(payload: entity.to_token_payload).token

    {
      'Authorization': "Bearer #{token}"
    }
  end

  def unauthenticated_header
    {
      'Authorization': "Bearer some_invalid_token"
    }
  end

  def json_response
    JSON.parse(response.body)
  end
end
