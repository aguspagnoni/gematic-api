class AdminUser < ApplicationRecord
  mount_uploader :image, PictureUploader
end
