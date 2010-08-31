
plugin "google :text" do |m|
  m.reply shorten_url("http://lmgtfy.com/?q=#{m.args[:text].gsub(/\s/, "+")}")
end

