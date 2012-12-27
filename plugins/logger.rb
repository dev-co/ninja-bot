class LoggerPlugin
  include NinjaPlugin

  match /grep (.+)/, :method => :grep

  listen_to :channel, :method => :log_channel
  listen_to :join, :method => :log_channel
  listen_to :part, :method => :log_channel

  def log_channel(m)
    return if !m.channel?

    message = m.message
    nick = m.user.nick
    type = "normal"
    if m.events.include?(:notice)
      type = "notice"
    elsif m.events.include?(:ctcp)
      type = "ctcp"
      message = m.ctcp_message

      if message =~ /^ACTION /
        type = "action"
        message.gsub!(/^ACTION /, "")
      end
    elsif m.events.include?(:join)
      type = "join"
      message = ""
    elsif m.events.include?(:part)
      type = "part"
    end

    data = {
      :nick => nick,
      :date => Time.now,
      :type => type
    }
    if !message.empty?
      data[:text] = message
    end

    Channel.add_log_message(m.channel.name, data)
  end

  def grep(m, query)
    if m.channel?
      regexp = Regexp.new(query) rescue Regexp.new(Regexp.escape(query))
      matches = []
      count = 0
      Log.where(:"messages.text" => regexp, :channel_id => m.channel.name, :limit => 5, :order => "created_at desc").all.each do |log|
        if count >= 10
          m.user.send ">>>> TOO MANY RESULTS<<<<<"
          break
        end

        log.messages.each do |message|
          if message["text"] =~ regexp && message["text"] !~ /^\!grep\s/
            m.user.send Log.format_message(message)

            count += 1
          end
        end
      end

    end
  end
end

#register_plugin LoggerPlugin
