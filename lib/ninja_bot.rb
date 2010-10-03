gem 'cinch', '~>1.0'
require 'cinch'
require 'chronic'

require 'ago'
Time.class_eval { alias :ago_in_words :ago}

gem 'mongo_mapper', '~>0.8'
require 'mongo_mapper'

require 'nokogiri'
require 'httparty'
require 'timeout'
require 'open-uri'
require 'mechanize'
require 'json'

require 'fixed_queue'
require 'ninja_plugin'
require 'core_ext'

class NinjaBot < Cinch::Bot
  def initialize(config)
    super()

    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

    load_plugins

    on(:disconnect) do |m|
      puts ">> Reconnecting..."
      @bot.start(false)
    end

    on(:nick) do |m|
      Cinch::Channel.all.each do |channel|
        channel.sync_modes
      end
    end
  end

  def history
    @history ||= {}
  end

  def self.database=(config)
    connection = Mongo::Connection.new(config[:host], config[:port])

    MongoMapper.connection = connection
    MongoMapper.database = config[:name]
    MongoMapper.database.authenticate(config[:user], config[:password]) if config[:user] && config[:password]
  end

  def self.known_plugins
    @known_plugins ||= []
  end

  def plugins
    instance_variable_get("@plugins")||[]
  end

  def localize!
    self.class.localize!
  end

  def self.localize!
    # TODO: load i18n
    Time.zone = self.ninja_config["timezone"] || "UTC"
  end

  def self.ninja_config
    @ninja_config ||= {}
  end

  def self.load_config(path)
    raw_config = File.read(path)
    @ninja_config = YAML.load(raw_config)

    Time.zone = @ninja_config["timezone"]
    NinjaBot.database = @ninja_config["database"]
    NinjaBot.load_models

    @ninja_config
  end

  private
  def self.load_models
    Dir[File.dirname(__FILE__)+"/../models/*.rb"].each do |f|
      require f
    end
  end

  def load_plugins
    puts "*"*80
    Dir[File.dirname(__FILE__)+"/../plugins/*.rb"].sort.each do |file|
      puts ">> Loading #{file}..."
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
