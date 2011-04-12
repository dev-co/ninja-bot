require "cgi"
require 'open-uri'

class WhatTheCommitPlugin
  include NinjaPlugin

  match /wtc/ 

  def usage
    "!wtc -- Gives a random commit message."
  end

  def execute( bot )
    wtc_url = 'http://whatthecommit.com/'
    commit  = ''
    begin
      document  = Nokogiri::HTML( open( wtc_url ).read )
      commit    = document.css( '#content p' ).first.children.text.gsub( /\n/, '' )
    rescue Exception
      commit    = 'fail.'
    end
    bot.reply "#{ bot.user.nick }: #{ commit }"
  end
end

register_plugin WhatTheCommitPlugin
