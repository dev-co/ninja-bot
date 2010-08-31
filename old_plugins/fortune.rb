
plugin "fortune" do |m|
  m.reply "#{m.nick}: #{`fortune`}".gsub(/[\n|\r|\t{2,}]/,' ')
end

