class Hashidator
  def self.validate(schema, input)
    hd = new(schema)
    hd.validate(input)
  end

  attr_accessor :schema, :errors

  def initialize(schema)
    @schema = schema
  end

  def validate(input)
    results = schema.map { |key, validator|
      validate_value(validator, input[key])
    }

    results.all?
  end

  private

  def validate_value(validator, value)
    case validator
    when Range
      validator.include? value
    when Array
      value.all? {|x| validate_value(validator[0], x) }
    when Symbol
      value.respond_to? validator
    when Regexp
      value.match validator
    when Hash
      Hashidator.validate(validator, value)
    when Class, Module
      value.is_a? validator
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
