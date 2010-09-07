class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String, :required => true
  belongs_to :channel

  key :nick, String, :required => true
  key :last_seen_at, Time
  key :last_quit_message, String

  key :given_points, Hash
  key :karma_up, Integer, :default => 0
  key :karma_down, Integer, :default => 0

  key :messages_count, Integer, :default => 0
  key :question_messages_count, Integer, :default => 0
  key :badword_messages_count, Integer, :default => 0
  key :command_messages_count, Integer, :default => 0

  key :fans, Array

  has_many :messages, :class_name => "Message"
  has_many :normal_messages, :type => "normal", :class_name => "Message"
  has_many :url_lists, :class_name => "UrlList"

  validates_uniqueness_of :nick, :scope => [:channel_id]

  def add_message(text)
    self.increment({:messages_count => 1})

    if self.karma_down == 0
      if self.messages_count+1 > 10 && self.karma_up < 5
        self.set({:karma_up => 5})
      elsif self.messages_count+1 > 100 && self.karma_up < 10
        self.set({:karma_up => 10})
      end
    end

    type = nil
    if text =~ /^\!/
      type = "command"
    elsif text =~ /\?/
      type = "question"
    elsif text =~ /\:\)/
      type = "happy"
    elsif text =~ /\:\(/
      type = "sad"
    elsif text =~ /\b(fuck|mofo|put(a|o)|mierda|shit|malpar|hijue)/
      type = "badword"
    end

    if type
      self.increment({:"#{type}_messages_count" => 1})
      message = self.messages.create(:type => type, :text => text)
    end
  end

  def add_url(url, title)
    today = Date.today.iso8601
    url_list = self.url_lists.find_or_create_by_day(today)
    url_list.add_to_set(:urls => {:link => url, :title => title})
  end

  def urls_for(day)
    date = case day.to_s.strip
    when "today"
      Date.today
    when "yesterday"
      Date.yesterday
    else
      Date.parse(day) rescue nil
    end

    if date && (url_list = self.url_lists.find_by_day(date.iso8601))
      url_list.urls
    else
      []
    end
  end

  def add_fan(nick)
    self.add_to_set({:fans => nick})
  end

  def given_points_today
    p = self.given_points[Date.today.iso8601].to_i
    self.set({:given_points => {}}) if p == 0
    p
  end

  def given_points_up!
    self.increment({:"given_points.#{Date.today.iso8601}" => 1})
  end

  def karma_up!
    self.increment({:karma_up => 1})
  end

  def karma_down!
    self.increment({:karma_down => 1})
  end

  def karma
    self.karma_up - self.karma_down
  end

  def can_increase_karma?
    self.given_points_today <= 3 && self.messages_count > 100 && self.karma >= 10
  end

  def can_decrease_karma?
    self.given_points_today <= 3 && self.messages_count > 100 && self.karma >= 50
  end
end

