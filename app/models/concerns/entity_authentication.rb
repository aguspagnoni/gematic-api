module EntityAuthentication
  extend ActiveSupport::Concern

  def to_token_payload
    { sub: id, entity: self.class.name }
  end

  module ClassMethods
    def from_token_payload payload
      return if self.name != payload['entity']
      self.find payload['sub']
    end
  end
end
