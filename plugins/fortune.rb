
on :channel, /^!fortune/ do
  msg channel, "#{nick}: #{`fortune`}"
end

