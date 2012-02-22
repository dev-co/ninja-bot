class PluginPlugin
  include NinjaPlugin

  match /plugin (\S+) (\d+) (.+)/, :method => :store_plugin
  listen_to :message, :method => :exec_plugin

  def initialize(*args)
    super(*args)
  end

  def usage
    "!plugin <name> <argc> <body> -- example: !plugin welcome 1 %s: welcome to $channel. I am $user -- usage: %welcome foo"
  end

  def store_plugin(m, name, argc, body)
    if plugin = PluginExt.where(:name=> name, :channel_id => m.channel.name).first
      plugin.argc = argc
      plugin.body = body
      plugin.save

      m.reply "#{m.user.nick}: plugin #{name} updated"
    else
      PluginExt.create!(:channel_id => m.channel.name, :name => name, :body => body, :argc => argc)
      m.reply "#{m.user.nick}: plugin #{name} saved"
    end
  end

  def exec_plugin(m)
    if m.message =~ /^\%(\S+)\s*(.*)/
      name = $1
      argv = $2.to_s.split(" ")

      plugin = PluginExt.where(:name=> name, :channel_id => m.channel.name)
      if plugin.nil?
        plugin = PluginExt.where(:name=> name)
      end

      if plugin.present?
        m.reply plugin.eval(m, argv)
      else
        m.reply "#{m.user.nick}: plugin #{name} not found"
      end
    end
  end
end

register_plugin PluginPlugin
