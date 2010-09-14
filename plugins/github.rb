require 'json'
require 'open-uri'

class GitHubPlugin
  include NinjaPlugin

  match /github (.+)/

  def usage
    "!github <query> -- repo search in github.com"
  end

  def execute(m, query)
    result = JSON.parse(open("http://github.com/api/v1/json/search/#{URI.escape(query)}").read)
    if result["repositories"].empty?
      reply = "I don't know to #{query} :|"
    else
      project = result["repositories"][0]
      reply = "#{project['name']}: http://github.com/#{project['username']}/#{project['name']}"
    end
    m.reply "#{m.user.nick}: #{reply}"
  end
end

register_plugin GitHubPlugin