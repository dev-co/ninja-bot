require 'rubygems'
require 'bundler/setup'

Bundler.require

Time.class_eval { alias :ago_in_words :ago}

require 'fixed_queue'
require 'ninja_plugin'
require 'core_ext'

Encoding.default_external = "UTF-8"

class NinjaBot < Cinch::Bot
  attr_reader :channel_list

  def initialize(config)
    super()

    @channel_list = {}
    config.delete(:channels).each do |c|
      @channel_list[c.delete("name")] = c
    end
    self.config.channels = @channel_list.keys

    config.each do |k, v|
      self.config.send("#{k}=", v)
    end

    load_plugins

    if config.keys.include? :password
      self.configure do |config|
        config.plugins.plugins.push Cinch::Plugins::Identify
        config.plugins.options[ Cinch::Plugins::Identify ] = {
          :username => config.nick,
          :password => config.passsword,
          :type     => :nickserv
        }
      end
    end

  end

  def history
    @history ||= {}
  end

  def self.database=(config)
    config[:database] = config.delete(:name)
    Mongoid.config.from_hash(config.stringify_keys)
    Mongoid.config.raise_not_found_error = false
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
