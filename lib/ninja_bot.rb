gem 'cinch', '~>1.0'
require 'cinch'

require 'ago'
Time.class_eval { alias :ago_in_words :ago}

gem 'mongo_mapper', '~>0.8'
require 'mongo_mapper'

require 'nokogiri'
require 'httparty'
require 'timeout'
require 'open-uri'
require 'mechanize'

require 'ninja_plugin'
require 'core_ext'

class NinjaBot < Cinch::Bot
  def initialize(config)
    super()

    self.class.database = config.delete(:database)||{}
    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

    self.class.load_models
    load_plugins

    on(:disconnect) do |m|
      puts ">> Reconnecting..."
      m.start(false)
    end
  end

  def self.database=(config)
    connection = Mongo::Connection.new(config[:host], config[:port])

    MongoMapper.connection = connection
    MongoMapper.database = config[:name]
    MongoMapper.database.authenticate(config[:user], config[:password]) if config[:user] && config[:password]
  end

  private
  def self.load_models
    Dir["./models/*.rb"].each do |f|
      require f
    end
  end

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
