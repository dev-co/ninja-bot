require 'json'
require 'open-uri'

plugin "github :text" do |m|
    text = m.args[:text]
    url = "http://github.com/api/v1/json/search/#{URI.escape(text)}"
    result = JSON.parse(open(url).read)
    if result["repositories"].empty?
      reply = "I don't know to #{text} :|"
    else
      project = result["repositories"][0]
      reply = "#{project['name']}: http://github.com/#{project['username']}/#{project['name']}"
    end
  
    m.reply "#{m.nick}: #{reply}"
end