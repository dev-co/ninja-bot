class GemDocPlugin
  include NinjaPlugin

  match /gemdoc (.+)/

  def usage
    "!gemdoc <query> -- search rubygem documentation"
  end

  def execute(m, query)
    xhtml = Nokogiri::HTML(open("http://rdoc.info/find/gems?q=#{URI.escape(query)}"))
    link = xhtml.css("ul.libraries li a:first").first
    result = "http://rdoc.info#{link[:href].to_s.gsub(/^#/, "")}"
    m.reply "#{m.user.nick}: #{result}"
  end
end

register_plugin GemDocPlugin

