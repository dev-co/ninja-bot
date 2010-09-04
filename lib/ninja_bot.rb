gem 'cinch', '~>1.0'
require 'cinch'
require 'nokogiri'
require 'httparty'
require 'timeout'
require 'open-uri'
require 'mechanize'
require 'ago'

gem 'mongo_mapper', '~>0.8'
require 'mongo_mapper'

require 'ninja_plugin'
require 'core_ext'

class NinjaBot < Cinch::Bot
  def initialize(config)
    super()

    self.database = config.delete(:database)||{}
    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

    load_plugins

    on(:disconnect) do |m|
      puts ">> Reconnecting..."
      m.start(false)
    end
  end

  def database=(config)
    connection = Mongo::Connection.new(config[:host], config[:port])
    connection.add_auth(config[:name], config[:user], config[:password]) if config[:user] && config[:password]

    MongoMapper.connection = connection
    MongoMapper.database = config[:name]
  end

  private
  def load_plugins
    puts "*"*80
    Dir["./plugins/*.rb"].each do |file|
      puts "loading #{file}..."
      begin
        eval File.read(file), binding, file
      rescue Exception => e
        puts "Cannot load: #{e.inspect}"
        sleep 3
      end
    end
    puts "*"*80
  end
end
