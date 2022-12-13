require 'rails_helper'

describe "Beer" do
    let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }

    let!(:user) { FactoryBot.create :user}
  
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
    end

    it "can be added when name is valid" do
        visit new_beer_path

        fill_in('beer[name]', with: 'IPA olut')
        select('IPA', from: 'beer[style]')
        select('Koff', from: 'beer[brewery_id]')

        expect{
            click_button "Create Beer"
        }.to change{Beer.count}.from(0).to(1)

    end

    it "can't be added without name" do
        visit new_beer_path

        select('IPA', from: 'beer[style]')
        select('Koff', from: 'beer[brewery_id]')

        expect{
            click_button "Create Beer"
        }. not_to change{Beer.count}

        expect(page).to have_content "Name can't be blank"
    end
end

