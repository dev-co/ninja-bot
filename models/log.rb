class Log
  include MongoMapper::Document

  timestamps!

  key :_id, String
  key :_type, String

  key :channel_id, String
  belongs_to :channel

  key :messages, Array
  key :messages_count, Integer, :default => 0


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
