require 'singleton'

class UserDb
  include Singleton

  def initialize
    @dbpath = File.expand_path("~/nbdb/")
    FileUtils.mkpath(@dbpath)
    puts "Initialized database in #{@dbpath}"
  end

  def parse(nick, chan, text)
    if text =~ /\?/
      store(nick, chan, "questions", text)
    elsif text =~ /^\!/
      store(nick, chan, "commands", text)
    elsif text =~ /fuck|fu|mofo|put(a|o)|mierda|shit|malpar|hijue|hijo\sde\sputa/i
      store(nick, chan, "badwords", text)
    end
  end

  def update_seen(nick, message = "")
    store(nick, "", "seen", "#{Time.now.to_i} #{message}", true)
  end

  def last_seen(nick)
    path = File.join(userdb_path(nick, ""), "seen")

    if File.exist?(path)
      time, message = File.read(path).split(" ", 2)
      [Time.at(time.to_i).ago, message]
    else
      nil
    end
  end

  protected
  def store(nick, chan, scope, data, clear = false)
    mode = "a"
    model = "w" if clear

    File.open(File.join(userdb_path(nick,chan),scope), mode) do |f|
      f.puts data
    end
  end

  def userdb_path(nick, chan)
    userdb_path = File.join(@dbpath,chan.to_s.downcase, nick.to_s.downcase)
    FileUtils.mkpath(userdb_path)
    userdb_path
  end
end

on :quit do |m|
  UserDb.instance.update_seen(m.nick, m.text)
end

plugin ":channel_message", :prefix => "" do |m|
  safe_run(m, m.args, m.nick, m.chan) do |m, args, nick, chan|
    UserDb.instance.parse(nick, chan, args[:channel_message])
  end
end

plugin "seen :target" do |m|
  safe_run(m, m.args, m.nick) do |m, args, nick|
    target = args[:target].downcase
    nick.downcase!
    if nick == target
      m.reply "#{nick}: you need a new brain"
    elsif (channel_names[m.channel] || []).include?(target)
      m.reply "#{nick}: you need new glasses"
    elsif seen = UserDb.instance.last_seen(target)
      m.reply "#{nick}: Last time I saw #{args[:target]} was #{seen.first}. it said: #{seen.last}"
    else
      m.reply "I've never seen that guy #{args[:target]} over here."
    end
  end
end
