require 'timeout'

on :channel, /^!eval_ruby (.*)/ do
  code = match.first
  result = ""
  Thread.start {
    $SAFE = 4
    begin
      Timeout.timeout(2) do
        result = Object.module_eval(code).inspect
      end
    rescue Timeout::Error
      result = "you suck as programmer boy"
    rescue SecurityError
      result = "I wanna be hahacker"
    rescue Exception
      result = "you are so smart... #{e.to_s}"
    end
  }.join

  msg channel, "#{nick}: #{result}"
end

