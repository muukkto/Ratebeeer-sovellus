class User < ApplicationRecord
  include AverageRating

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /\A[A-Z].*\d|\d.*[A-Z]\z/, message: "must include one upper case letter and number" }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = Style.all
    a = styles.to_h { |x| [x, [0]] }

    ratings.each do |rating|
      a[rating.beer.style].insert(-1, rating.score)
    end

    a.max_by{ |_t, b| b.sum(0.0) / b.size }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = Brewery.all
    a = breweries.to_h { |x| [x, [0]] }
    ratings.each do |rating|
      a[rating.beer.brewery].insert(-1, rating.score)
    end

    a.max_by{ |_t, b| b.sum(0.0) / b.size }[0].name
  end
end
