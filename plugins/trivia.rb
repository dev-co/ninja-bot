on :message do |m|
  @current_question ||= {}
  @last_ping_at ||= {}
  @current_delay ||= {}
  @tries ||= {}

  if m.channel && !Thread.current[:locked_at]
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

    channel = m.channel
    irc_user = m.user

    if channel && irc_user && (question = @current_question[channel.name])
      if m.events == [:channel, :message]
        if question.answer =~ /^#{Regexp.escape(m.message)}$/i
          @current_question[channel.name] = nil
          @tries[channel.name] = 0

          user = Channel.get_user(channel.name, irc_user.nick)
          user.karma_up!
          m.reply "#{user.nick}: correct!!! the answer was '#{question.answer}'. you have earned 1 point of karma"
          Thread.current[:locked_at] = Time.now
        else
          answer = question.answer
          @tries[channel.name] ||= 0
          @tries[channel.name]+=1

          if @tries[channel.name] == 5
            m.reply "TIP: #{answer[0,answer.length-1].gsub(/\S/, " _")+" "+answer[answer.length-1]}"
          end
        end
      end
    end

    if @current_delay[chan] && (@last_ping_at[chan].nil? || (Time.now - @last_ping_at[chan]) > @current_delay[chan])
      if @current_question[chan]
        m.reply "TIMEOUT! The answer was: #{@current_question[chan].answer}"
      end

      question = @current_question[chan] = Question.random_question
      Thread.current[:locked_at] = nil

      @last_ping_at[chan] = Time.now
      @tries[chan] = 0

      question.increment({:asked_times => 1})
      words = question.answer.split(/\s+/).size

      m.reply "[#{question.category}] #{question.text} (#{words} words)"
    end
  end

  if Thread.current[:locked_at] && (Time.now - Thread.current[:locked_at]) > 1.minute
    Thread.current[:locked_at] = true
  end
end

