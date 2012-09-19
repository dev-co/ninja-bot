# encoding: utf-8

require 'weatherboy'
require 'iconv'

class WeatherPlugin
  include NinjaPlugin

  match /weather (.+)/

  def usage
    "!weather <location> -- weather information"
  end

  def execute(m, loc)
    info = Weatherboy.new(loc).current
    puts info.inspect
    txt = "#{m.user.nick}: conditions: #{info.weather}, temp: #{info.temp_c}°C, #{info.relative_humidity} humidity, #{info.wind_mph} m/h #{info.wind_dir}, visibility: #{info.visibility_km} KM"

    m.reply txt
  end

  private
  def clean_entry(text)
    Iconv.conv("UTF-8", 'ISO-8859-1', text)
  end
end

register_plugin WeatherPlugin

