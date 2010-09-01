class GemDocPlugin
  include NinjaPlugin

  match /gemdoc (.+)/

  def usage
    "gemdoc <query> -- search ruby gems"
  end

  def execute(m, query)
    xhtml = Nokogiri::HTML(open("http://rdoc.info/projects/search?q=#{URI.escape(query)}"))
    links = xhtml.css(".projects .project a")[0,10]
    result = links.map do |link|
      "http://rdoc.info#{link[:href]}"
    end.join(" -- ")
    m.reply "#{m.user.nick}: #{result}"
  end
end

register_plugin GemDocPlugin

