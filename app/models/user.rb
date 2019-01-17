class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites
  has_many :favorings, through: :favorites, source: :micropost  # 現在のUserがお気に入りしているMicropostの集まりを取得する

  has_many :relationship1s
  has_many :likings, through: :relationship1s, source: :like
  has_many :reverses_of_relationship1, class_name: 'Relationship1', foreign_key: 'like_id'
  has_many :likers, through: :reverses_of_relationship1, source: :user
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

  def favorite(other_micropost)
    # other_micropostを現在のUserがお気に入りするインスタンスメソッド
    self.favorites.find_or_create_by(micropost_id: other_micropost.id)
  end

  def unfavorite(other_micropost)
    favorite = self.favorites.find_by(micropost_id: other_micropost.id)
    favorite.destroy if favorite
  end

  def favorings?(other_micropost)
   self.favorings.include?(other_micropost)
  end
  
  


end
