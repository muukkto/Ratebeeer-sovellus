class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  include AverageRating

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -b.average_rating }
    sorted_by_rating_in_desc_order.take(n)
  end
end
