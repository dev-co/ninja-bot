
plugin "url :text" do |m|
  short = shorten_url(m.args[:text])
  if !short.blank?
    m.reply "#{m.nick}: #{short}"
  end
end

