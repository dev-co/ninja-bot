require 'open-uri'

class RubyDoc
  def execute(bot, query)
    count = 0

    baseurl = "http://ruby-doc.org/ruby-1.9"
    doc = Nokogiri::HTML(open("#{baseurl}/fr_class_index.html"))

    result = "not found"
    doc.css("a").each do |link|
      if link.text.strip.downcase == query.downcase
        result = "#{link.text} #{baseurl}/#{link["href"]}"
        break
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

