require 'json'
require 'open-uri'

class GemPlugin
  include NinjaPlugin

  match /gem (.+)/

  def usage
    "!gem <gem-name> -- search on rubygems.org"
  end

  def execute(m, query)
    begin
      result = JSON.parse(open("http://rubygems.org/api/v1/gems/#{URI.escape(query)}.json").read)
      reply = "#{result['name']} (by #{result['authors']}): #{result['project_uri']}"
    rescue
      reply = "I don't know any #{query} gem :/"
    end

    m.reply "#{m.user.nick}: #{reply}"
  end
end

register_plugin GemPlugin
