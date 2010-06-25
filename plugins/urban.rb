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

plugin "urban :text" do |m|
  #begin
    xhtml = Nokogiri::HTML( UrbanDictionary::Search.new( m.args[:text] ).fetch )
    xhtml.xpath( '//table[@id="entries"]/tr[2]//div[@class="definition"]' ).each do | definition |
      if ( definition.content )
	m.reply "#{m.nick}: #{definition.content.gsub( /([\n\t])+{1,}/, " " ).strip}"
      end
    end

  #rescue Exception => e
  #  p e
  #end    
end
