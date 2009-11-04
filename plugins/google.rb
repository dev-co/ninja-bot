
on :channel, /^!google (.*)/ do
  msg channel, shorten_url("http://lmgtfy.com/?q=#{match.first.gsub(/\s/, "+")}")
end

