module NinjaPlugin
  def self.included(base)
    base.send(:include, Cinch::Plugin)
  end

  def usage
    raise NotImplementedError
  end

  def shorten_url(url)
    open("http://bit.ly/api?url=#{url}").read rescue nil
  end
end
