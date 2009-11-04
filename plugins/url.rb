
on :channel, /^!url (.*)/ do
  short = shorten_url(match.first)
  if !short.blank?
    msg channel, "#{nick}: #{short}"
  end
end

