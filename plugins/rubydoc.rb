require 'open-uri'

class RubyDoc
  def execute(bot, query)
    count = 0

    base_url = "http://ruby-doc.org/ruby-1.9"
    klass, method = query.split(/\#|\s/, 2)

    agent = Mechanize.new
    page = agent.get("#{base_url}/fr_class_index.html")
    klass_link = page.link_with(:text => /^\s*#{Regexp.escape(klass)}\s*$/i )

    result = "not found"
    if klass_link
      url = "#{base_url}/#{klass_link.uri.to_s}"

      found = false
      if method
        page = klass_link.click
        if method_link = page.link_with(:text => /^\s*#{Regexp.escape(method)}\s*$/i)
          ref = method_link.node["href"].sub("#", "")
          section = page.parser.css("#method-#{ref}").first
          if section
            found = true
            signature = section.css(".method-signature").first.content.strip.gsub(/\s+/, " ")
            description = section.css(".method-description p").first.content[0,250].strip.gsub(/\s+/, " ")

            result = "#{signature}: #{description}.. #{url}##{ref}"
          end
        end
      end

      if !found
        result = "#{klass_link.text} #{url}"
      end
    end

    bot.reply "#{bot.nick}: #{result}"
  end
end

plugin "rubydoc :text" do |m|
  safe_run(m, m.args) do |m, args|
    RubyDoc.new.execute(m, args[:text])
  end
end

