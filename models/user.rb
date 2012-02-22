class User
  include Mongoid::Document
  include MongoidExt::Random
  include Mongoid::Timestamps

  identity :type => String

  field :channel_id, :type => String, :required => true
  belongs_to :channel

  field :nick, :type => String, :required => true
  field :last_seen_at, :type => Time
  field :last_quit_message, :type => String


  field :lastfm_user, :type => String
  field :coderwall_user, :type => String

  field :given_points, :type => Hash
  field :karma_up, :type => Integer, :default => 0
  field :karma_down, :type => Integer, :default => 0

  field :messages_count, :type => Integer, :default => 0
  field :question_messages_count, :type => Integer, :default => 0
  field :badword_messages_count, :type => Integer, :default => 0
  field :command_messages_count, :type => Integer, :default => 0

  field :fans, :type => Array, :default => []

  has_many :messages, :class_name => "Message"
  has_many :normal_messages, :class_name => "Message"
  has_many :url_lists, :class_name => "UrlList"

  validates_uniqueness_of :nick, :scope => [:channel_id]

  def add_message(text, type = nil)
    self.increment({:messages_count => 1})

    return if text.split(" ").size < 2

    if self.karma_down == 0
      if self.messages_count+1 > 10 && self.karma_up < 5
        self.override({:karma_up => 5})
      elsif self.messages_count+1 > 100 && self.karma_up < 10
        self.override({:karma_up => 10})
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
    url_list = self.url_lists.where(:day => today).first
    if !url_list
      url_list = self.url_lists.create(:day => today)
    end
    url_list.push_uniq(:urls => {:link => url, :title => title})
  end

  def urls_for(day)
    if day == "all"
      urls = Set.new
      UrlList.where(:user_id => self.id).all.each do |url|
        urls += url.urls
      end

      return urls.to_a
    end

    date = Chronic.parse(day.to_s.strip).in_time_zone.to_date rescue nil

    if date && (url_list = self.url_lists.where(:day => date.iso8601).first)
      url_list.urls
    else
      []
    end
  end

  def add_fan(nick)
    self.add_to_set(:fans,  nick)
  end

  def given_points_today
    p = self.given_points[Date.today.iso8601]
    if p.nil?
      self.override({:given_points => {}})
      self.override({:"given_points.#{Date.today.iso8601}" => 0})
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

