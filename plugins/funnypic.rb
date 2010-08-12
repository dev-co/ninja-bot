require 'open-uri'
plugin "pic" do |m|
  safe_run(m) do |m|
    pic = "i don't want to work today!"
    xhtml = Nokogiri::HTML( open("http://randomfunnypicture.com") )
    img = xhtml.css('center a[@href="http://randomfunnypicture.com/?random"] img').first

    if img
      pic = "#{img["alt"].sub(/^funny pictures /, "")} -- #{shorten_url(img["src"])}"
    end

    m.reply "#{m.nick}: #{pic}"
  end
end

