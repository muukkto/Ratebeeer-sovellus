class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  include AverageRating
  extend TopList
end
