class Hashidator
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
    when Range
      validator.include? value
    when Array
      value.respond_to?(:all?) && value.all? {|x| validate_value(validator[0], x)}
    when Symbol
      value.respond_to? validator
    when Regexp
      validator.match value.to_s
    when String
      validator == value
    when Hash
      Hashidator.validate(validator, value)
    when Class, Module
      value.is_a? validator
    when Proc
      result = validator.call(value)
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
