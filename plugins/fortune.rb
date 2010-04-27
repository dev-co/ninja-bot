
on :channel, /^!fortune/ do
  msg channel, "#{nick}: #{`fortune`}".gsub(/[\n|\r|\t{2,}]/,' ')
end

