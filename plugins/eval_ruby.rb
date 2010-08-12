plugin "eval_ruby :text" do |m|
  safe_run(m) do |m|
    code = m.args[:text]
    result = ""

    Thread.start {
      $SAFE = 4
      begin
        result = Object.module_eval(code).inspect
      rescue SecurityError
        result = "nah nah, you suck man"
      rescue Exception => e
        result = "you are so smart... #{e.to_s}"
      end
    }.join
    m.reply "#{m.nick}: #{result}"
  end
end

