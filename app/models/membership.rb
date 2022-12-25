class Membership < ApplicationRecord
  belongs_to :beer_club
  belongs_to :user

  scope :confirmed, -> { where confirmed: true }
  scope :applicant, -> { where confirmed: false }
end
