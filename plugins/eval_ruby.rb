require 'timeout'

on :channel, /^!eval_ruby (.*)/ do
  code = match.first
  result = ""
  begin
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
  rescue Timeout::Error
    result = "you suck as programmer boy"
  end

  msg channel, "#{nick}: #{result}"
end

