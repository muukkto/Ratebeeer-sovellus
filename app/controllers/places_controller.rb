class PlacesController < ApplicationController
  def index
  end

  def show
    city = Rails.cache.read(session[:last_search])
    @place = nil
    city.each do |place|
      @place = place if place.id == params[:id]
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.get_weather_in(params[:city])
    @city = params[:city]

    session[:last_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
