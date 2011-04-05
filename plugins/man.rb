class ManPlugin
  include NinjaPlugin

  match /man (.+)/

  def usage
    "!man <command> -- linux man"
  end

  def execute(m, cmd)
    output = `whatis #{cmd}`
    if $?.success?
      m.reply "#{m.user.nick}: #{output}"
    end
  end
end

register_plugin ManPlugin

