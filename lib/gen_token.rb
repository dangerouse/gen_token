module GenToken

  # Usage:
  # include GenToken
  # gen_token :key, :type => :hex, :length => AppConfig.token.token_length
  # gen_token :password, :type => :hex, :length => AppConfig.token.token_length
  
  module GenTokenClassMethods
    def gen_token(key, options = {})
      token_def = {:name => key, :type => :hex, :length => 16}.merge(options)
      write_inheritable_array(:token_fields, [token_def])
    end
  end
  
  module ActiveRecordInstanceMethods
    def generate_tokens
      self.class.read_inheritable_attribute(:token_fields).each do |token|
        name, type, length = token[:name], token[:type], token[:length]
        self[token[:name]] = ActiveSupport::SecureRandom.send(:"#{token[:type]}", token[:length])
        while !self.class.send(:"find_by_#{token[:name]}", self[token[:name]]).nil?
          self[token[:name]] = ActiveSupport::SecureRandom.send(:"#{token[:type]}", token[:length])
        end
      end
    end
  end
  
  def self.included(klass)
    klass.extend GenTokenClassMethods
    if Object.const_defined?(:ActiveRecord)
      if klass < ActiveRecord::Base
        klass.send :include, ActiveRecordInstanceMethods
        klass.before_validation(:generate_tokens, :on => :create)
      end
    end
  end
  
end