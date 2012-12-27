module UrbanDictionary
  class Search
    include HTTParty

    def initialize(term)
      @query = {}
      @query[:term] = "#{term}" if term && term.strip != ''
      self
    end

    def user_agent
      @user_agent = 'Ruby Twitter Gem'
    end

    def fetch()
      response = self.class.get('http://www.urbandictionary.com/define.php', :query => @query, :headers => {'User-Agent' => user_agent})
    end
  end
end


class UrbanPlugin
  include NinjaPlugin

  match /urban (.+)/

  def usage
    "!urban <word> -- urban dictionary plugin"
  end

  def execute(m, word)
    xhtml = Nokogiri::HTML(UrbanDictionary::Search.new(word).fetch)
    xhtml.xpath( '//table[@id="entries"]/tr[2]//div[@class="definition"]' ).each do |definition|
      if definition.content
        m.reply "#{m.user.nick}: #{definition.content.gsub( /([\n\t])+{1,}/, " " ).strip}"
      end
    end
  end
end

#register_plugin UrbanPlugin
