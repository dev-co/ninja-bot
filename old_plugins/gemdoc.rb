require 'mechanize'

plugin "gemdoc :text" do |m|
  safe_run(m, m.args) do |m, args|
    xhtml = Nokogiri::HTML(open("http://rdoc.info/projects/search?q=#{URI.escape(args[:text])}"))
    links = xhtml.css(".projects .project a")[0,10]
    result = links.map do |link|
      "http://rdoc.info#{link[:href]}"
    end.join(" -- ")
    m.reply "#{m.nick}: #{result}"
  end
end
