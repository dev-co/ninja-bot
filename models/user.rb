class User
  include MongoMapper::Document

  key :_id, String

  key :channel_id, String, :required => true
  belongs_to :channel

  key :nick, String, :required => true

  key :messages_count, Integer, :default => 0

  has_many :messages, :class_name => "Message"
  has_many :normal_messages, :type => "normal", :class_name => "Message"

  validates_uniqueness_of :nick, :scope => [:channel_id]

  def add_message(txt)
    puts "Add message: #{text}"
    self.increment({:messages_count => 1})
    self.increment({:"#{type}_messages_count" => 1})

#     message = self.messages.create(:type => type, :text => txt)
  end
end
