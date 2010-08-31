class EvalRubyPlugin
  include NinjaPlugin

  match /ruby (.+)/

  def usage
    "!fortune -- display a random adage"
  end

  def execute(m, code)
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

    m.reply "#{m.user.nick}: #{result}"
  end
end

register_plugin EvalRubyPlugin
