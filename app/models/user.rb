class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  validates :introduction, length: {maximum: 50}
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :revirse_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following_users, through: :relationships, source: :followed
  has_many :follower_users, through: :revirse_relationships, source: :follower

  # ユーザーをフォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # ユーザーをアンフォローする
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているかを確認する
  def following?(user)
    following_users.include?(user)
  end
 

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
