require 'open-uri'
plugin "pic" do |m|
  safe_run(m) do |m|
    5.times do
      sources = {
        :failblog => ['http://randomfunnypicture.com', 'center a[@href="http://randomfunnypicture.com/?random"] img'],
        :rfp => ['http://failblog.org/?random', '.snap_preview img'],
        :demot => ['http://verydemotivational.com/?random', '.snap_preview img'],
        :comixed => ['http://comixed.com/?random', '.snap_preview img']
      }
      source = sources[sources.keys.at(rand(sources.keys.size))]

      pic = ""

      xhtml = Nokogiri::HTML(open(source[0]))
      img = xhtml.css(source[1]).first

      if !img
        puts "#{source} failed!"
        next
      end

      pic = "#{img["alt"].sub(/^funny pictures /, "")} -- #{shorten_url(img["src"])}"

      m.reply "#{m.nick}: #{pic}"
      break
    end
  end
end
