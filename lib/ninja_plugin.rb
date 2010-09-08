module NinjaPlugin
  def self.included(base)
    base.send(:include, Cinch::Plugin)
    NinjaBot.known_plugins << base
  end

  def usage
    ""
  end

  def shorten_url(url)
    open("http://bit.ly/api?url=#{url}").read rescue url
  end

  def parse_url(url)
    xhtml = Nokogiri::HTML(open(url))
    content = ""
    if /https?:\/\/([a-z]*\.)?twitter.com\/(\w+)\/status(es)?\/(\d+)/ =~ url
      xhtml.xpath('//span[@class="entry-content"]').each do |tweet|
        content = tweet.content.gsub(/([\n\t])+{1,}/, " ").strip if tweet.content
      end
    elsif /https?:\/\/identi.ca\/notice\/(\d+)/ =~ url
      xhtml.xpath('//p[@class="entry-content"]').each do |tweet|
        content = tweet.content.gsub(/([\n\t])+{1,}/, " ").strip if tweet.content
      end
    else
      xhtml.xpath("//head/title").each do |title|
        content = title.content.gsub(/([\n\t])+{1,}/, " ").strip if title.content
      end
    end

    content
  end
end
