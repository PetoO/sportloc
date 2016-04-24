class Location < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :photos, dependent: :destroy
  mount_uploader :image, ImageUploader
  acts_as_votable
  acts_as_taggable
end
