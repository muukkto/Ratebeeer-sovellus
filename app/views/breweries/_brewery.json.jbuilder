json.extract! brewery, :id, :name, :year, :active
json.beer do
  json.number brewery.beers.count
end
json.url brewery_url(brewery, format: :json)
