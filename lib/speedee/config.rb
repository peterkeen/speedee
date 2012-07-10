module Speedee::Config

  class ConfigError < StandardError; end

  def self.get(section, key)
    val = `notmuch config get #{section}.#{key} 2>&1`
    exit_code = $? >> 8
    if exit_code > 0
      raise ConfigError.new(val)
    else
      return val.chomp
    end
  end

  def self.get_list(pattern)
    `notmuch config list`.split("\n").grep(pattern).map do |v|
      v.gsub(pattern, '')
    end
  end

end
