require 'rails_helper'

describe "Beerlist page" do
  before :all do
    Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new app, browser: :chrome,
          options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
    end
    
    Capybara.javascript_driver = :chrome
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path

    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js:true do
    visit beerlist_path
    expect(find('#beertable').find('.tablerow:nth-of-type(1)')).to have_content "Fastenbier"
    expect(find('#beertable').find('.tablerow:nth-of-type(2)')).to have_content "Lechte Weisse"
    expect(find('#beertable').find('.tablerow:nth-of-type(3)')).to have_content "Nikolai"

  end  

  it "shows beers in order by style, when ordered", js:true do
    visit beerlist_path
    find('span', text: 'Style').click
    expect(find('#beertable').find('.tablerow:nth-of-type(1)')).to have_content "Nikolai"
    expect(find('#beertable').find('.tablerow:nth-of-type(2)')).to have_content "Fastenbier"
    expect(find('#beertable').find('.tablerow:nth-of-type(3)')).to have_content "Lechte Weisse"

  end  

  it "shows beers in order by brewery, when ordered", js:true do
    visit beerlist_path
    find('span', text: 'Brewery').click
    expect(find('#beertable').find('.tablerow:nth-of-type(1)')).to have_content "Lechte Weisse"
    expect(find('#beertable').find('.tablerow:nth-of-type(2)')).to have_content "Nikolai"
    expect(find('#beertable').find('.tablerow:nth-of-type(3)')).to have_content "Fastenbier"

  end  
end