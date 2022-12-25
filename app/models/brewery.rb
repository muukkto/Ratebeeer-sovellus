class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  include AverageRating
  extend TopList

  validates :name, presence: true
  validate :year_cannot_be_in_the_future, on: :create
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_cannot_be_in_the_future
    return unless year > Time.now.year

    errors.add(:year, "can't be in the future")
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  def to_s
    name
  end
end
