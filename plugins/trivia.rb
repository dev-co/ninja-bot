on :message do |m|
  @current_question ||= {}
  @last_ping_at ||= {}
  @current_delay ||= {}

  if m.channel
    chan = m.channel.name

    if m.message =~ /trivia (.+)$/
      if $1 == "off"
        @current_delay[chan] = nil
      elsif $1 == "on"
        @current_delay[chan] = 10.minutes
      elsif $1.to_i > 0
        @current_delay[chan] = $1.to_i
      end
    end

    if @current_delay[chan] && @last_ping_at[chan].nil? || (Time.now - @last_ping_at[chan]) > @current_delay[chan]
      @last_ping_at[chan] = Time.now

      question = @current_question[chan] = Question.random_question
      question.increment({:asked_times => 1})
      words = question.answer.split(/\s+/).size

      m.reply "[#{question.category}] #{question.text} (#{words} words)"
    end
  end
end

on :message do |m|
  @current_question ||= {}

  channel = m.channel
  irc_user = m.user

  if channel && irc_user && (question = @current_question[channel.name])
    if m.events == [:channel, :message] && question.answer =~ /^#{Regexp.escape(m.message)}$/i
      @current_question[channel.name] = nil

      user = Channel.get_user(channel.name, irc_user.nick)
      user.karma_up!
      m.reply "#{user.nick}: correct!!! the answer was '#{question.answer}'. you have earned 1 point of karma"
    end
  end
end
