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

  def safe_run(bot, *args, &block)
    Thread.start(bot, args) do |bot, args|
      begin
        block.call(bot, *args)
      rescue Exception => e
        bot.reply "#{e.message} -- #{e.backtrace[0,5].join(", ")}"
      end
    end
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
    puts "*"*80
    Dir["./plugins/*.rb"].each do |file|
      puts "loading #{file}..."
      begin
        eval File.read(file)
      rescue Exception => e
        puts "Cannot load: #{e.inspect}"
      end
    end
    puts "*"*80
  end
end
