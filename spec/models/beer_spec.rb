require 'rails_helper'

RSpec.describe Beer, type: :model do
  describe "with a proper brewery," do
    let(:test_brewery){ Brewery.new name: "test", year: 2000 }

    it "name and style is saved" do
      beer = Beer.create name: "testi_olut", style: "IPA", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "but without style beer is not saved" do
      beer = Beer.create name: "testi_olut", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "but without name beer is not saved" do
      beer = Beer.create style: "IPA", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end    
  end
end
