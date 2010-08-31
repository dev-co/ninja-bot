require 'open-uri'

class JavaDoc
  def execute(bot, query)
    count = 0

    klass, method = query.split(/\s|\.|\#/, 2)

    agent = Mechanize.new
    baseurl = nil
    link = nil
    page = nil

    ["http://download-llnw.oracle.com/javase/6/docs/api",
     "http://download.oracle.com/javaee/6/api"].each do |url|
      page = agent.get("#{url}/allclasses-noframe.html") rescue nil

      if page && (link = page.link_with(:text => /^\s*#{Regexp.escape(klass)}\s*$/i))
        baseurl = url
        break
      end
    end

    result = "not found"
    found = false

    if link
      title = "#{link.text} #{link.node["title"]}"

      url = "#{baseurl}/#{link.uri.to_s}"
      if method
        page = link.click
        if link = page.link_with(:href => /#{Regexp.escape(method)}\(\)$/i, :text => /#{Regexp.escape(method)}$/i)
          found = true
          ref = link.uri.to_s.split("%23", 2).last
          desc = link.node.parent.parent.parent.content.gsub("\n", "").gsub(/\s+/, " ")
          result = "#{title} #{desc} #{url}##{ref}"
        end
      end

      if !found
        result = "#{title} #{url}"
      end
    end

    bot.reply "#{bot.nick}: #{result}"
  end
end

plugin "javadoc :text" do |m|
  safe_run(m, m.args) do |m, args|
    JavaDoc.new.execute(m, args[:text])
  end
end

