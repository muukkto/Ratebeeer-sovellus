class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, -> { distinct }, through: :memberships
end
