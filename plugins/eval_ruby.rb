class EvalRubyPlugin
  include NinjaPlugin
  BLACKLIST = %w[ Thread Dir File FileUtils ]

  match /ruby (.+)/

  def usage
    "!ruby <code> -- evals ruby code"
  end

  def execute(m, code)
    result = ""

    if is_unsafe? code
      result = "don't try to hack me, you fucker!"
    else
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
    end

    m.reply "#{m.user.nick}: #{result[0,200]}"
  end

  protected

    def is_unsafe?(code)
      code =~ /(Thread|Dir|File|FileUtils)\./
    end

    # This will return a regular expression that looks like this:
    # /(Thread|Dir|File|FileUtils)/
    def blacklist
      Regexp.new "(#{ BLACKLIST.join '|' })"
    end

end

#register_plugin EvalRubyPlugin
