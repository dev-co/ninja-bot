require 'json'
require 'open-uri'

plugin "gem :text" do |m|
    safe_run(m, m.args) do |m, args|
      url = "http://rubygems.org/api/v1/gems/#{URI.escape(args[:text])}.json"
      begin
        result = JSON.parse(open(url).read)
        reply = "#{result['name']} (by #{result['authors']}): #{result['project_uri']}"
      rescue
        reply = "I don't know to #{args[:text]} gem :/"
      end
  
      m.reply "#{m.nick}: #{reply}"
    end
end