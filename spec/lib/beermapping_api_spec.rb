require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-YKSI
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      YKSI

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "when HTTP GET returns none entries, method returns empty hash" do

      empty_answer = <<-KAKSI
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      KAKSI
    
      stub_request(:get, /.*espoo/).to_return(body: empty_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(0)
    end

    it "when HTTP GEY returns many entries, they are parsed and returned" do

      long_answer = <<-KOLME
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>580</id><name>Heartland Brewery Union Square</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/580</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=580&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=580&amp;d=1&amp;type=norm</blogmap><street>35 Union Square West</street><city>New York</city><state>NY</state><zip>10003</zip><country>United States</country><phone>(212) 645-3400</phone><overall>66.6666</overall><imagecount>0</imagecount></location><location><id>3167</id><name>Cafe d'Alsace</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/3167</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=3167&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=3167&amp;d=1&amp;type=norm</blogmap><street>1695 2nd Avenue</street><city>New York City</city><state>NY</state><zip>10128</zip><country>United States</country><phone>212-722-5133</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>1403</id><name>West End, The</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/1403</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=1403&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=1403&amp;d=1&amp;type=norm</blogmap><street>2911 Broadway</street><city>New York</city><state>NY</state><zip>10025</zip><country>United States</country><phone>(212) 662-8830</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      KOLME

      stub_request(:get, /.*new%20york/).to_return(body: long_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("new york")    

      expect(places.size).to eq(3)
      place1 = places.first
      place2 = places.second
      place3 = places.last
      expect(place1.name).to eq("Heartland Brewery Union Square")
      expect(place2.name).to eq("Cafe d'Alsace")
      expect(place3.name).to eq("West End, The")

    end
  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-YKSI
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      YKSI

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end

    it "when HTTP GET returns none entries, method returns empty hash" do

      empty_answer = <<-KAKSI
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      KAKSI
    
      stub_request(:get, /.*espoo/).to_return(body: empty_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("espoo")
      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(0)
    end

    it "when HTTP GEY returns many entries, they are parsed and returned" do

      long_answer = <<-KOLME
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>580</id><name>Heartland Brewery Union Square</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/580</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=580&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=580&amp;d=1&amp;type=norm</blogmap><street>35 Union Square West</street><city>New York</city><state>NY</state><zip>10003</zip><country>United States</country><phone>(212) 645-3400</phone><overall>66.6666</overall><imagecount>0</imagecount></location><location><id>3167</id><name>Cafe d'Alsace</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/3167</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=3167&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=3167&amp;d=1&amp;type=norm</blogmap><street>1695 2nd Avenue</street><city>New York City</city><state>NY</state><zip>10128</zip><country>United States</country><phone>212-722-5133</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>1403</id><name>West End, The</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/1403</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=1403&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=1403&amp;d=1&amp;type=norm</blogmap><street>2911 Broadway</street><city>New York</city><state>NY</state><zip>10025</zip><country>United States</country><phone>(212) 662-8830</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      KOLME

      stub_request(:get, /.*new%20york/).to_return(body: long_answer, headers: { 'Content-Type' => "text/xml" })

      BeermappingApi.places_in("new york")
      places = BeermappingApi.places_in("new york")    

      expect(places.size).to eq(3)
      place1 = places.first
      place2 = places.second
      place3 = places.last
      expect(place1.name).to eq("Heartland Brewery Union Square")
      expect(place2.name).to eq("Cafe d'Alsace")
      expect(place3.name).to eq("West End, The")

    end
  end
end