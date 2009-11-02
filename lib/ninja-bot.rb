require 'rubygems'
require 'isaac'
require 'nokogiri'
require 'httparty'

class NinjaBot < Isaac::Bot
  def initialize(config, channels)
    super()
    configure do |c|
      config.each do |k,v|
        c.send("#{k}=", v)
      end
    end

    on :connect do
      join channels
    end
    core_events
    load_plugins
  end

  private
  def core_events
    on :channel, /^!join\s+(.*)/ do
      if nick == "kuadrosx"
        join match.first
      else
        msg channel, "#{nick} you aren't my father"
      end
    end

    on :channel, /^!say\s+(.*)/ do
      msg channel, match.first
    end
  end

  def load_plugins
    begin
      puts "*"*80
      Dir["./plugins/*.rb"].each do |file|
        puts "loading #{file}..."
        require file
      end
      puts "*"*80
    rescue StandardError => e
      puts e.inspect
    end
  end
end

