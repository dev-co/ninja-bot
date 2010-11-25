require 'feedzirra'

class ShapadoPlugin
  include NinjaPlugin

  timer 5.minutes.to_i, :method => :find_question
  match /shapado (.+)/

  def usage
    "!shapado <query> -- query on shapado"
  end

  def find_question()
    $stderr.puts @bot.channel_list.inspect
    @bot.channel_list.each do |name, config|
      next if config["shapado_site"].blank?

      result = parse_feed(config["shapado_site"], config[:last_modified] || Time.now)

      config[:last_modified] = result[:last_modified]
      last_parse = Time.now

      if result[:entries].size > 0
        buffer = "new questions on #{config["shapado_site"]}: "
        result[:entries].each do |question|
          buffer << "#{question[:title]} #{question[:url]} -- "
        end

        Channel(name).send(buffer)
      end
    end
  end

  def execute(m, query)
    if m.channel
      config = @bot.channel_list[m.channel.name]
      data = JSON.parse(open("#{config["shapado_site"]}/search.json?q=rvm").read)
      buffer = ""
      data[0,6].each do |q|
        buffer << "#{config["shapado_site"]}/questions/#{q["slug"]} -- "
      end

      m.reply buffer
    end
  end

  private
  def parse_feed(site, from_date)
    feed = Feedzirra::Feed.fetch_and_parse("#{site}/questions.atom")

    last_modified = Time.parse(feed.last_modified)

    new_entries = []
    feed.entries.each do |entry|
      date = Time.parse(entry.published) || Time.parse(entry.updated)

      if date > from_date
        new_entries << {:url => shorten_url(entry.url), :title => entry.title, :date => date}
      end
    end

    {:last_modified => last_modified, :entries => new_entries}
  end
end

register_plugin ShapadoPlugin

