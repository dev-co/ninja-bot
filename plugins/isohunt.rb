require 'json'

class IsoHuntPlugin
  include NinjaPlugin

  match /isohunt (.+)/

  def usage
    "!isohunt -- search on isohunt.com"
  end

  def execute(bot, query)
    items = JSON.parse(open("http://isohunt.com/js/json.php?ihq=#{CGI.escape(query.capitalize)}&rows=20&sort=seeds").read)

    count = 0
    pattern = query.split(" ").map { |e| /#{Regexp.escape(e)}/i }
    items["items"]["list"].each do |item|
      title = item["title"].gsub(/<\/?[^>]*>/, "")
      next unless pattern.find {|p| title.match(p).nil? }.nil?

      if count == 0
        bot.reply "#{bot.user.nick}: #{title} #{item["enclosure_url"]} #{item["size"]} s:#{item["Seeds"]} l:#{item["leechers"]} v:#{item["votes"]}"
      else
        bot.user.send "#{title} #{item["enclosure_url"]} #{item["size"]} s:#{item["Seeds"]} l:#{item["leechers"]} v:#{item["votes"]}"
      end

      break if (count+=1) == 4
    end
  end
end

class SubDivXPlugin
  include NinjaPlugin

  match /subs (.+)/

  def usage
    "!subs -- search subtitles in spanish"
  end

  def execute(bot, query)
    count = 0
    pattern = query.split(" ").map { |e| Regexp.escape(e) }.join("|")

    doc = Nokogiri::HTML(open("http://subdivx.com/index.php?buscar=#{CGI.escape(query)}&accion=5&masdesc=&subtitulos=1&realiza_b=1"))

    doc.css("#buscador_detalle").each do |detalle|
      description = detalle.css("#buscador_detalle_sub").text

      next if description !~ /#{pattern}/i

      link = detalle.css('a[@target="new"]').first["href"]
      if count == 0
        bot.reply "#{bot.user.nick}: #{description} #{link}"
      else
        bot.user.send "#{description} #{link}"
      end

      break if (count+=1) == 4
    end
  end
end

register_plugin IsoHuntPlugin
register_plugin SubDivXPlugin
