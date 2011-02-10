class PluginExt
  include MongoMapper::Document

  timestamps!

  key :_id, String
  key :_type, String

  key :name, String
  key :body, String
  key :argc, Integer, :default => 0

  key :channel_id, String

  validates_uniqueness_of :name, :scope => [:channel_id]

  def eval(m, argv)
    begin
      ret = self[:body] % argv
      ret.gsub!(/\$channel/, m.channel.name)
      ret.gsub!(/\$user/, m.user.nick)
      ret.gsub!(/\$now/, Time.now.to_s)
    rescue ArgumentError => e
      ret = "#{m.user.nick}: ERROR: #{e.to_s}. Usage: %#{self.name} #{(0..argc).map{|e| "arg#{e}" }}"
    end

    ret
  end
end
