require 'open-uri'
require 'json'

class IsoHunt
  def execute(bot, query)
    items = JSON.parse(open("http://isohunt.com/js/json.php?ihq=#{CGI.escape(query)}&rows=20&sort=seeds").read)

    count = 0
    pattern = query.split(" ").map { |e| /#{Regexp.escape(e)}/i }
    items["items"]["list"].each do |item|
      title = item["title"].gsub(/<\/?[^>]*>/, "")
      next unless pattern.find {|p| title.match(p).nil? }.nil?

      bot.reply "#{bot.nick}: #{title} #{item["enclosure_url"]} #{item["size"]} s:#{item["Seeds"]} l:#{item["leechers"]} v:#{item["votes"]}"

      break if (count+=1) == 4
    end
  end
end

plugin "isohunt :text" do |m|
  safe_run(m, m.args) do |m, args|
    IsoHunt.new.execute(m, args[:text])
  end
end

class SubDivX
  def execute(bot, query)
    count = 0
    pattern = query.split(" ").map { |e| Regexp.escape(e) }.join("|")

    doc = Nokogiri::HTML(open("http://subdivx.com/index.php?buscar=#{CGI.escape(query)}&accion=5&masdesc=&subtitulos=1&realiza_b=1"))
    doc.css("#buscador_detalle").each do |detalle|
      description = detalle.css("#buscador_detalle_sub").text

      next if description !~ /#{pattern}/i

      link = detalle.css('a[@target="new"]').first["href"]
      bot.reply "#{bot.nick}: #{description} #{link}"

      break if (count+=1) == 4
    end
  end
end

plugin "subs :text" do |m|
  safe_run(m, m.args) do |m, args|
    SubDivX.new.execute(m, args[:text])
  end
end
