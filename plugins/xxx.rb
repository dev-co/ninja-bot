require 'xxx'
plugin "xxx" do |m|
  safe_run(m) do |m|
    #channel = Xxx.send(:open_channel, Xxx::CHANNEL_NAMES.at(rand(Xxx::CHANNEL_NAMES.size)))
    channel = Xxx::Youporn.new
    m.reply "#{m.nick}: NSFW #{channel.latest} NSFW"
  end
end

