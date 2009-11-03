on :channel, /^!eval_ruby (.*)/ do
  code = match.first
  result = ""
  Thread.start {
    $SAFE = 4
    begin
    result = Object.module_eval(code).inspect
    rescue Exception
      result = "you are so smart..."
    end
  }.join

  msg channel, "#{nick}: #{result}"
end

