class Photo < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :location
end
