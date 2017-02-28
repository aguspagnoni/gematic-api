class Claim < ApplicationRecord
  belongs_to :order
  belongs_to :client
  belongs_to :admin_user
end
