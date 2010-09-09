class EvalRubyPlugin
  include NinjaPlugin

  match /ruby (.+)/

  def usage
    "!ruby <code> -- evals ruby code"
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

    m.reply "#{m.user.nick}: #{result[0,200]}"
  end
end

register_plugin EvalRubyPlugin
