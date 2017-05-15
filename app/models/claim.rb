class Claim < ApplicationRecord
  belongs_to :order
  belongs_to :user
  belongs_to :admin_user
end
