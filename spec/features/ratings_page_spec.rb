require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "Karjala", brewery:brewery }
  let!(:user) { FactoryBot.create :user, username: "Pekka" }
  let!(:user2) { FactoryBot.create :user, username: "Simo"}

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when user make ratings" do
    let!(:rating1) { FactoryBot.create :rating, beer:beer1, user:user, score: 10}
    let!(:rating2) { FactoryBot.create :rating, beer:beer2, user:user, score: 5}
    let!(:rating3) { FactoryBot.create :rating, beer:beer3, user:user2}

    it "ratings are shown on ratings page" do

        visit ratings_path

        expect(page).to have_content "Number of ratings: 3"
        expect(page).to have_content rating1.beer.name
        expect(page).to have_content rating2.beer.name
        expect(page).to have_content rating3.beer.name
    end

    it "correct ratings, is shown on users page" do

        visit user_path(user)

        expect(page).to have_content rating1.beer.name
        expect(page).to have_content rating2.beer.name
        expect(page).not_to have_content rating3.beer.name
    end

    it "user can delete ratings" do
        visit user_path(user)

        expect{
            page.first(:link, "Delete").click
          }.to change{Rating.count}.by(-1)
    end

    it "user have favorite style, beer and brewery" do
        visit user_path(user)

        expect(page).to have_content "Favorite beer: #{rating1.beer.name}"
        expect(page).to have_content "Favorite brewery: #{rating1.beer.brewery.name}"
        expect(page).to have_content "Favorite style: #{rating1.beer.style}"
    end
  end
end