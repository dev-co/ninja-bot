module NinjaPlugin
  def self.included(base)
    base.send(:include, Cinch::Plugin)
    NinjaBot.known_plugins << base
  end

  def usage
    raise NotImplementedError
  end

  def shorten_url(url)
    open("http://bit.ly/api?url=#{url}").read rescue url
  end
end
