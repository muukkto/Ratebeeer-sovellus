class WeatherApi
  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
  
    return response["current"]

    #places = response.parsed_response["bmp_locations"]["location"]

    #return [] if places.is_a?(Hash) && places['id'].nil?

    #places = [places] if places.is_a?(Hash)
    #places.map do |place|
    #  Place.new(place)
    #end
  end

  def self.key
    return nil if Rails.env.test?
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?
    ENV.fetch('WEATHER_APIKEY')
  end
end
