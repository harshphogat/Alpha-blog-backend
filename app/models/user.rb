class User < ApplicationRecord
  before_save { self.email = email.downcase }
  has_many :articles, dependent: :destroy

  has_many :received_follows, foreign_key: :followed_user_id, class_name: 'Follow'
  has_many :followers, through: :received_follows, source: :follower

  has_many :given_follows, foreign_key: :follower_id, class_name: 'Follow'
  has_many :followings, through: :given_follows, source: :followed_user

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 105 }, format: { with: VALID_EMAIL_REGEX }
  VALID_PASSWORD_REGEX = /\A
                          (?=.{8,})
                          (?=.*\d)
                          (?=.*[a-z])
                          (?=.*[A-Z])
                          (?=.*[[:^alnum:]])
                        /x
  validates :password, presence: true, format: { with: VALID_PASSWORD_REGEX }
  has_secure_password
end
