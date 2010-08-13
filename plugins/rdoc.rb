require 'mechanize'

plugin "rdoc :text" do |m|
  safe_run(m) do |m|
    xhtml = Nokogiri::HTML(open("http://rdoc.info/projects/search?q=#{URI.escape(m.args[:text])}"))
    links = xhtml.css(".projects .project a")[0,10]
    result = links.map do |link|
      "http://rdoc.info#{link[:href]}"
    end.join(" -- ")
    m.reply "#{m.nick}: #{result}"
  end
end
