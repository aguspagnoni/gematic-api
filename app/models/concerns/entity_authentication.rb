module EntityAuthentication
  def to_token_payload
    { sub: id, entity: self.class.name.downcase }
  end
end
