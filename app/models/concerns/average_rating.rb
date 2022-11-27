module AverageRating
    extend ActiveSupport::Concern
    def average_rating
        pisteet = ratings.map(&:score)
        pisteet.sum(0.0) / pisteet.size
    end
end