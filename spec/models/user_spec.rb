require 'rails_helper'

def create_beer_with_rating(object, score, style = FactoryBot.create(:style), brewery = FactoryBot.create(:brewery))
  beer = FactoryBot.create(:beer, style: style, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password containing only lowercase" do
    user = User.create username: "Pekka", password: "pienet", password_confirmation: "pienet"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password under 4 characters" do
    user = User.create username: "Pekka", password: "Lyh", password_confirmation: "Lyh"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
  
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for detemining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating if several rated" do
      ipa_1 = create_beer_with_rating({ user: user}, 25, FactoryBot.create(:style, name: "IPA"))
      ipa_2 = create_beer_with_rating({ user: user}, 20, FactoryBot.create(:style, name: "IPA"))
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)

      expect(user.favorite_style.name).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for detemining the favorite style" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite style" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery.name).to eq(beer.brewery.name)
    end

    it "is the one with highest rating if several rated" do
      koff_p = FactoryBot.create(:brewery, name: "Koff")
      koff_1 = create_beer_with_rating({ user: user}, 25, FactoryBot.create(:style, name: "IPA"), koff_p)
      koff_2 = create_beer_with_rating({ user: user}, 20, FactoryBot.create(:style, name: "IPA"), koff_p)
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
    
      expect(user.favorite_brewery.name).to eq("Koff")
    end
  end

end