class Client < ApplicationRecord
  has_many :billing_info
  has_many :orders

  mount_uploader :image, PictureUploader
end
