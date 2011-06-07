class Hashidator
  autoload :VERSION, 'hashidator/version'

  def self.validate(schema, input)
    new(schema).validate(input)
  end

  attr_accessor :schema

  def initialize(schema)
    @schema = schema
  end

  def validate(input)
    input ||= {}
    schema.all? {|key, validator|
      validate_value(validator, input[key])
    }
  end

  private

  def validate_value(validator, value)
    case validator
    when Array
      value.respond_to?(:all?) && value.all? {|x| validate_value(validator[0], x)}
    when Hash
      value.respond_to?(:[]) && validator.all? {|k, v| validate_value(v, value[k]) }
    when Symbol
      value.respond_to? validator
    else
      result = validator == value
      result = validator === value unless result
      result = validate_value(result, value) unless Boolean === result
      result
    end
  end
end

module Boolean
end

class TrueClass
  include Boolean
end

class FalseClass
  include Boolean
end

class Proc
  alias :=== :call if RUBY_VERSION < "1.9"
end
