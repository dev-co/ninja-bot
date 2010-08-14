require 'json'
require 'open-uri'

plugin "gem :text" do |m|
    url = "http://rubygems.org/api/v1/gems/#{URI.escape(m.args[:text])}.json"
    begin
      result = JSON.parse(open(url).read)
      reply = "#{result['name']} (by #{result['authors']}): #{result['project_uri']}"
    rescue
      reply = "I don't know to #{text} gem :/"
    end
  
    m.reply "#{m.nick}: #{reply}"
end