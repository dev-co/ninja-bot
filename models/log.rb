class Log
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel

  field :messages, :type => Array, :default => []
  field :messages_count, :type => Integer, :default => 0


  def self.format_message(msg)
    if msg["type"] == "normal"
      "[#{msg["date"]}] <#{msg["nick"]}> #{msg["text"]}"
    elsif msg["type"] == "action"
      "[#{msg["date"]}] * #{msg["nick"]} #{msg["text"]}"
    elsif msg["type"] == "join"
      "[#{msg["date"]}] JOIN #{msg["nick"]}"
    elsif msg["type"] == "part"
      "[#{msg["date"]}] PART #{msg["nick"]}"
    elsif msg["type"] == "ctcp"
      "[#{msg["date"]}] CTCP #{msg["nick"]} #{msg["text"]}"
    end
  end
end
