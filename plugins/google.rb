
on :channel, /^!google (.*)/ do
  msg channel, "http://lmgtfy.com/?q=#{match.first.gsub(/\s/, "+")}"
end

