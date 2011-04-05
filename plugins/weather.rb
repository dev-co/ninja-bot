# encoding: utf-8

require 'vendor/google_weather'
require 'iconv'

class WeatherPlugin
  include NinjaPlugin

  match /weather (.+)/

  def usage
    "!weather <location> -- weather information"
  end

  def execute(m, loc)
    info = GoogleWeather.forecast(loc)
    puts info.inspect
    txt = "#{m.user.nick}: #{clean_entry(info[:location][:city])}, conditions: #{info[:current][:conditions]}, temp: #{info[:current][:temp_c]}°C, #{info[:current][:humidity]}, #{info[:current][:wind]}"

    m.reply txt
  end

  private
  def clean_entry(text)
    Iconv.conv("UTF-8", 'ISO-8859-1', text)
  end
end

register_plugin WeatherPlugin

