require 'geocoder'

class Geocode

  attr_reader :city, :country

  def initialize(gpx)
    @gpx = gpx
    self.geocode
  end

  def geocode

    geocode_options = {
        timeout: 10
    }

    begin

      location = Geocoder.search([@gpx.points.first.latitude,@gpx.points.first.longitude],geocode_options)[0].data["address_components"]

      @city = get_geocoder_param(location,"locality")
      @country = get_geocoder_param(location,"country")

    rescue

      @city = nil
      @country = nil

    end

  end

  def get_geocoder_param(location,type)
    e = location.select { |e| e['types'][0] == type}
    e[0]["long_name"]
  end

end