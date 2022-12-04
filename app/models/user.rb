class User < ApplicationRecord
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs,  -> { distinct }, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :uppercase
  validate :contains_number

  def uppercase
    return if !!password.match(/\p{Upper}/)

    errors.add :password, ' must contain at least 1 uppercase '
  end

  def contains_number
    return if password.count("0-9") > 0

    errors.add :password, ' must contain at least one number'
  end

  include AverageRating

  has_secure_password
end
