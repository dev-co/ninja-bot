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

  def add_message(text, type = nil)
    self.increment({:messages_count => 1})

    return if text.split(" ").size < 2

    if self.karma_down == 0
      if self.messages_count+1 > 10 && self.karma_up < 5
        self.set({:karma_up => 5})
      elsif self.messages_count+1 > 100 && self.karma_up < 10
        self.set({:karma_up => 10})
      end
    end

    type ||= if text =~ /^\!/
      "command"
    elsif text =~ /\?/
      "question"
    elsif text =~ /(\:\)|xD|\:\-\)|\(\:)/
      "happy"
    elsif text =~ /\:\(/
      "sad"
    elsif text =~ /\b(fuck|mofo|put(a|o)|mierda|shit|malpar|hijueput|gono)/
      "badword"
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
    if day == "all"
      urls = Set.new
      UrlList.find_each(:user_id => self.id) do |url|
        urls += url.urls
      end

      return urls.to_a
    end

    date = Chronic.parse(day.to_s.strip).in_time_zone.to_date rescue nil

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
    p = self.given_points[Date.today.iso8601]
    if p.nil?
      self.set({:given_points => {}})
      self.set({:"given_points.#{Date.today.iso8601}" => 0})
    end

    p.to_i
  end

  def given_points_up!
    self.given_points[Date.today.iso8601] ||= 0
    self.given_points[Date.today.iso8601] += 1
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

