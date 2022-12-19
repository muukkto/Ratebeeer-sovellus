require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    allow(WeatherApi).to receive(:get_weather_in).with("helsinki").and_return(
      {"observation_time"=>"07:14 PM", "temperature"=>1, "weather_code"=>116, "weather_icons"=>["https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"], "weather_descriptions"=>["Partly cloudy"], "wind_speed"=>17, "wind_degree"=>200, "wind_dir"=>"SSW", "pressure"=>1018, "precip"=>0, "humidity"=>93, "cloudcover"=>75, "feelslike"=>-5, "uv_index"=>1, "visibility"=>10, "is_day"=>"no"}
    )

    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if many are returned by the APi, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("pasila").and_return(
        [ Place.new( name: "Pikajuna", id: 1 ), Place.new( name: "Bär Bar", id: 2), Place.new( name: "Ratamo", id: 3)]
    )

    allow(WeatherApi).to receive(:get_weather_in).with("pasila").and_return(
      {"observation_time"=>"07:14 PM", "temperature"=>1, "weather_code"=>116, "weather_icons"=>["https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"], "weather_descriptions"=>["Partly cloudy"], "wind_speed"=>17, "wind_degree"=>200, "wind_dir"=>"SSW", "pressure"=>1018, "precip"=>0, "humidity"=>93, "cloudcover"=>75, "feelslike"=>-5, "uv_index"=>1, "visibility"=>10, "is_day"=>"no"}
    )

    visit places_path
    fill_in('city', with: 'pasila')
    click_button "Search"

    expect(page).to have_content "Pikajuna"
    expect(page).to have_content "Bär Bar"
    expect(page).to have_content "Ratamo"

  end

  it "if none are returned, a message is shown" do
    allow(BeermappingApi).to receive(:places_in).with("töölö").and_return(
        []
    )

    allow(WeatherApi).to receive(:get_weather_in).with("töölö").and_return(
      {"observation_time"=>"07:14 PM", "temperature"=>1, "weather_code"=>116, "weather_icons"=>["https://cdn.worldweatheronline.com/images/wsymbols01_png_64/wsymbol_0004_black_low_cloud.png"], "weather_descriptions"=>["Partly cloudy"], "wind_speed"=>17, "wind_degree"=>200, "wind_dir"=>"SSW", "pressure"=>1018, "precip"=>0, "humidity"=>93, "cloudcover"=>75, "feelslike"=>-5, "uv_index"=>1, "visibility"=>10, "is_day"=>"no"}
    )

    visit places_path
    fill_in('city', with: 'töölö')
    click_button "Search"

    expect(page).to have_content "No locations in töölö"

  end    
end