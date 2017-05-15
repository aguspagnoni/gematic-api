class User < ApplicationRecord
  belongs_to :company
  mount_uploader :image, PictureUploader
end
