module NinjaPlugin
  def self.included(base)
    base.send(:include, Cinch::Plugin)
  end

  def usage
    raise NotImplementedError
  end
end
