$KCODE = 'u'

require 'rubygems'
require 'cinch'
require 'nokogiri'
require 'httparty'

require 'core_ext'

class NinjaBot < Cinch::Base
  def initialize(config)
    super(config)

    core_events
    load_plugins
  end

  protected
  def shorten_url(url)
    open("http://bit.ly/api?url=#{url}").read rescue nil
  end

  private
  def core_events
#    on :channel, /^!join\s+(.*)/ do
#      if nick == "kuadrosx"
#        join match.first
#      else
#        msg channel, "#{nick} you aren't my father"
#      end
#    end

    plugin "say :text" do |m|
      m.reply m.args[:text]
    end
  end

  def load_plugins
    begin
      puts "*"*80
      Dir["./plugins/*.rb"].each do |file|
        puts "loading #{file}..."
        eval File.read(file)
      end
      puts "*"*80
    rescue StandardError => e
      puts e.inspect
    end
  end
end
