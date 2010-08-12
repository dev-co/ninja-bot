require 'open-uri'
plugin "pic" do |m|
  Thread.start(m) do |m|
    pic = "i don't want to work today!"
    open("http://randomfunnypicture.com").each do |line|
      if line =~ %r{src="(http://www\.randomfunnypicture.com/pictures/(\S+))"\s}
        puts "FOUND: #{$1}"
        pic = shorten_url($1)
        break
      end
    end

	  m.reply "#{m.nick}: #{pic}"
  end
end

