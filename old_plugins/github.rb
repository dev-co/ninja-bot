require 'json'
require 'open-uri'

plugin "github :text" do |m|
    safe_run(m, m.args) do |m, args|
      url = "http://github.com/api/v1/json/search/#{URI.escape(args[:text])}"
      result = JSON.parse(open(url).read)
      if result["repositories"].empty?
        reply = "I don't know to #{args[:text]} :|"
      else
        project = result["repositories"][0]
        reply = "#{project['name']}: http://github.com/#{project['username']}/#{project['name']}"
      end
  
      m.reply "#{m.nick}: #{reply}"
    end
end