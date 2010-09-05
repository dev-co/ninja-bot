class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String, :required => true
  belongs_to :channel

  key :nick, String, :required => true
  key :last_seen_at, Time
  key :last_quit_message, String

  key :karma, Integer, :default => 0

  key :messages_count, Integer, :default => 0
  key :question_messages_count, Integer, :default => 0
  key :badword_messages_count, Integer, :default => 0
  key :command_messages_count, Integer, :default => 0

  has_many :messages, :class_name => "Message"
  has_many :normal_messages, :type => "normal", :class_name => "Message"

  validates_uniqueness_of :nick, :scope => [:channel_id]

  def add_message(text)
    self.increment({:messages_count => 1})

    type = nil
    if text =~ /^\!/
      type = "commmand"
    elsif text =~ /\?/
      type = "question"
    elsif text =~ /fuck|fu|mofo|\sput(a|o)\s|mierda|shit|malpar|hijue/
      type = "badword"
    end

    if type
      self.increment({:"#{type}_messages_count" => 1})
      message = self.messages.create(:type => type, :text => text)
    end
  end

  def karma_up!
    self.increment({:karma => 1})
  end

  def karma_down!
    self.decrement({:karma => 1})
  end
end
