plugin "ruby :text" do |m|
  safe_run(m, m.args) do |m, args|
    code = args[:text]
    result = ""

    Timeout.timeout(2) do
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
    end

    m.reply "#{m.nick}: #{result}"
  end
end

