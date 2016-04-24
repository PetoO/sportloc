class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :locations, dependent: :destroy
  has_many :comments, dependent: :destroy
  mount_uploader :avatar, AvatarUploader
  has_many :photos, dependent: :destroy
  acts_as_voter
end
