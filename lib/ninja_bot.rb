gem 'cinch', '1.0.1'
require 'cinch'
require 'nokogiri'
require 'httparty'
require 'timeout'
require 'open-uri'
require 'mechanize'
require 'ago'

require 'ninja_plugin'
require 'core_ext'

class NinjaBot < Cinch::Bot
  def initialize(config)
    super()

    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

   load_plugins
  end

  private
  def load_plugins
    puts "*"*80
    Dir["./plugins/*.rb"].each do |file|
      puts "loading #{file}..."
      begin
        eval File.read(file)
      rescue Exception => e
        puts "Cannot load: #{e.inspect}"
        sleep 3
      end
    end
    puts "*"*80
  end
end
