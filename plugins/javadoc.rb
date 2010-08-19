require 'open-uri'

class JavaDoc
  def execute(bot, query)
    count = 0

    baseurl = "http://download-llnw.oracle.com/javase/6/docs/api"
    doc = Nokogiri::HTML(open("#{baseurl}/allclasses-noframe.html"))

    result = "not found"
    doc.css("a").each do |link|
      if link.text.strip.downcase == query.downcase
        result = "#{link["title"]} #{baseurl}/#{link["href"]}"
        break
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

